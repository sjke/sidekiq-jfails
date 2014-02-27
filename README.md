# Sidekiq::Jfails [![Gem Version](https://badge.fury.io/rb/sidekiq-jfails.png)](http://badge.fury.io/rb/sidekiq-jfails) [![Dependency Status](https://gemnasium.com/sjke/sidekiq-jfails.png)](https://gemnasium.com/sjke/sidekiq-jfails) [![Build Status](https://travis-ci.org/sjke/sidekiq-jfails.png?branch=master)](https://travis-ci.org/sjke/sidekiq-jfails) [![Code Climate](https://codeclimate.com/repos/530ee9fde30ba068e0000d31/badges/d041c9480e3db6b2072b/gpa.png)](https://codeclimate.com/repos/530ee9fde30ba068e0000d31/feed)

Keeps track of fails in Sidekiq jobs in web and provides detailed information on the fail
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-jfails', '~> 0.0.2'
# OR
gem 'sidekiq-jfails', git: 'git://github.com/sjke/sidekiq-jfails.git', tag: '0.0.2'
```
## Usage

Simply having the gem in your Gemfile is enough to get you started.
Your failed jobs will be visible via a Job fails tab in the Web.

## Configuring

### Maximum Count Fails

This parameter sets the count of tracking fails.
Default of 10 000 maximum tracked fails.

To change the maximum count:

```ruby
Sidekiq.configure_server do |config|
  config.jfails_max_count = 1590
end
```
To disable the limit entirely:

```ruby
Sidekiq.configure_server do |config|
  config.jfails_max_count = 0
end
```
### Fails per page

This parameter sets the count of fails displayed per page.
Default of 10 fails per page.

To change the per page:

```ruby
Sidekiq.configure_server do |config|
  config.fails_per_page = 15
end
```

## Dependencies

Depends on Sidekiq >= 2.17

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature-desc`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin feature-desc`)
5. Create new Pull Request

## License

Released under the MIT License. See the [LICENSE][license] file for further details.

[license]: https://github.com/sjke/sidekiq-jfails/blob/master/LICENSE
