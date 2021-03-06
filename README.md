# ExceptionNotifier::FluentLoggerNotifier

`ExceptionNotifier::FluentLoggerNotifier` is a custom notifier for [ExceptionNotification](http://smartinez87.github.io/exception_notification/).
It sends exception notifications to [Fluentd data collector](http://fluentd.org/) via [fluent-logger](https://github.com/fluent/fluent-logger-ruby).

## Installation

Add this line to your application's Gemfile:

    gem 'exception_notification-fluent_logger_notifier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exception_notification-fluent_logger_notifier

## Usage

As other exception notifiers, add settings at the environments.

* Key `tag_prefix` is for the fluentd tag.
* Key `template` is for setting log format and must be Hash.
* Key `logger_settings` is for settings of the logger instance.
* If key `test_logger` is `true`, the notifier uses `Fluent::Logger::TestLogger` instead of `FluentLogger`.

See also [exception\_notifier's doc](http://smartinez87.github.io/exception_notification/#notifiers).

### Example

```ruby
Whatever::Application.config.middleware.use ExceptionNotification::Rack,
  fluent_logger: {
    tag_prefix: "exceptions",
    logger_settings: {
      host: "localhost",
      port: 8888,
    }
    template: {
      exception_class: ->(exception, options) { exception.class_name },
      exception_message: => -> (exception, options) { exception.messaage },
    }
  }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

[MIT](http://makimoto.mit-license.org/)
