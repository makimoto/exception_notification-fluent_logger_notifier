lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "exception_notifier/fluent_logger_notifier/version"

Gem::Specification.new do |spec|
  spec.name          = "exception_notification-fluent_logger_notifier"
  spec.version       = ExceptionNotifier::FluentLoggerNotifier::VERSION
  spec.authors       = ["Shimpei Makimoto"]
  spec.email         = ["makimoto@tsuyabu.in"]
  spec.summary       = %q{A custom notifier for ExceptionNotification which notifies exceptions to Fluentd via fluent-logger}
  spec.homepage      = "https://github.com/makimoto/exception_notification-fluent_logger_notifier"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_dependency "exception_notification", "~> 4.0.1"
  spec.add_dependency "fluent-logger"
end
