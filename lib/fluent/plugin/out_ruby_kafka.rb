# coding: utf-8

class RubyKafkaOutput < Fluent::Output
  Fluent::Plugin.register_output('ruby_kafka', self)

  config_param :zookeepers, :string, :default => nil

  config_param :brokers, :string, :default => nil

  config_param :default_topic, :string, :default => nil

  config_param :max_queue_size, :integer, :default => 1000

  config_param :delivery_threshold, :integer, :default => 0

  config_param :delivery_interval, :integer, :default => 0

  config_param :retry_count, :integer, :default => 3

  config_param :output_include_tag, :bool, :default => false

  config_param :output_include_time, :bool, :default => false

  config_param :use_kafka_log, :bool, :default => false

  @seed_brokers = []

  def initialize
    super
    require "kafka"
    require "zookeeper"
    require "json"
  end

  def configure(conf)
    super
    @seed_brokers = []
    if @zookeepers
      z = Zookeeper.new(@zookeepers)
      z.get_children(:path => '/brokers/ids')[:children].each do |id|
        broker = Yajl.load(z.get(:path => "/brokers/ids/#{id}")[:data])
        @seed_brokers.push("#{broker['host']}:#{broker['port']}")
      end
      z.close
      log.info "brokers has been refreshed via Zookeeper: #{@seed_brokers}"
    end

    if @seed_brokers.empty? and @brokers
      @seed_brokers = @brokers.match(",").nil? ? [@brokers] : @brokers.split(",")
      log.info "brokers has been set directly: #{@seed_brokers}"
    end

    raise Fluent::ConfigError, "Broker has not been set." if @seed_brokers.empty?

    kafka = Kafka.new(seed_brokers: @seed_brokers, logger: @use_kafka_log ? log : nil)
    @producer = kafka.async_producer(
      max_queue_size: @max_queue_size,
      delivery_threshold: @delivery_threshold,
      delivery_interval: @delivery_interval,
    )
  end

  def start
    super
  end

  def shutdown
    super
    @producer.shutdown if @producer
  end

  def emit(tag, es, chain)
    chain.next
    es.each do |time,record|
      record['time'] = time if @output_include_time
      record['tag'] = tag if @output_include_tag
      topic = record['topic'] || @default_topic || tag

      data = JSON.dump(record)
      retry_counter = 0
      begin
        retry_counter += 1
        @producer.produce(data, topic: topic)
      rescue Kafka::BufferOverflow
        if retry_counter <= @retry_count
          log.warn "Buffer overflow, backing off for 1s. #{retry_counter} time."
          sleep 1
          retry
        else
          raise
        end
      end
    end
  end

end
