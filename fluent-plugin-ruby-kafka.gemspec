# coding: utf-8

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-ruby-kafka"
  gem.version       = "0.1.0"
  gem.authors       = ["Yoshimitsu Kokubo"]
  gem.email         = ["yoshi@unplus.net"]
  gem.summary       = %q{Kafka's produce fluentd plugin by ruby-kafka}
  gem.description   = %q{Kafka's produce fluentd plugin by ruby-kafka}
  gem.homepage      = "https://github.com/unplus/fluent-plugin-ruby-kafka"
  gem.license       = "Apache-2.0"

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "test-unit"
  gem.add_dependency "fluentd", '>= 0.10.59'
  gem.add_dependency "ruby-kafka", '~> 0.3.0', '>= 0.3.2'
  gem.add_dependency "zookeeper", '~> 1.4.0', '>= 1.4.11'
end
