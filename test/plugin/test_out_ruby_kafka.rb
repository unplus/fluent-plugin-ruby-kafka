require 'helper'

class RubyKafkaOutputTest < Test::Unit::TestCase

  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
      zookeepers zookeeper01:2181,zookeeper02:2181
      default_topic topic1
      max_queue_size 1000
      delivery_threshold 0
      delivery_interval 0
      output_include_tag  true
      output_include_time true
      log_level info
  ]

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::OutputTestDriver.new(RubyKafkaOutput, tag).configure(conf)
  end

end
