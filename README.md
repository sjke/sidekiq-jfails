# Sidekiq::Jfails

Keeps track of fails in Sidekiq jobs in web and provides detailed information on the fail
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-jfails', git: 'git@github.com:sjke/sidekiq-jfails.git'
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
