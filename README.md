# Universign

A ruby client for the Universign XML-RPC api.
Based on Universign documentation Version: 7.12.1 and 8.2.5

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'universign'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install universign

## Usage

### Test 

See [test.rb](https://github.com/mgtf/universign/blob/master/spec/test.rb)

### Configuration options

```ruby
Universign.configure do |config|
  config.user = '<usually your email>'
  config.password = '<password>'
  config.language = 'fr'
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mgtf/universign. 
This project is intended to be a safe, welcoming space for collaboration, and contributors are 
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
