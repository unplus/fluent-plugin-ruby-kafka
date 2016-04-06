# fluent-plugin-ruby-kafka

[Fluentd](http://fluentd.org/) output plugin to write data into kafka topic.

It has been implemented in the reference [fluent-plugin-kafka](https://github.com/htgc/fluent-plugin-kafka)

The difference between fluent-plugin-kafka are using [ruby-kafka](https://github.com/zendesk/ruby-kafka).

## Configuration

### RubyKafkaOutput

Use zookeeper:

    <match tag.**>
      type ruby_kafka
      zookeepers zookeeper01:2181,zookeeper02:2181
      default_topic topic1
    </match>

Setting the brokers:

    <match tag.**>
      type ruby_kafka
      brokers broker01:9092,broker02:9092
      default_topic topic1
    </match>

## TODO

## Copyright

* Copyright (c) 2016- Yoshimitsu KOKUBO (yoshi)
* License
  * Apache License, Version 2.0
