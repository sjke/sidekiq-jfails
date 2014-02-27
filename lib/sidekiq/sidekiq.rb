require 'sidekiq/web'
require 'sidekiq/jfails/middleware'
require 'sidekiq/jfails/web'

module Sidekiq

  # Sets the maximum number of fails to track
  #
  # If the number of failures exceeds this number the list will be trimmed (oldest
  # failures will be purged).
  #
  # Defaults to 10 000
  # Set to 0 to disable rotation
  def self.jfails_max_count=(value)
    @jfails_max_count = value
  end

  def self.jfails_max_count
    return 10000 unless @fails_logger_max_count
    @jfails_max_count
  end

  # Sets the maximum fails per page
  #
  # Defaults to 10
  def self.fails_per_page=(value)
    @fails_per_page = value
  end

  def self.fails_per_page
    return 10 unless @fails_logger_max_count
    @fails_per_page
  end

  module Jfails
    LIST_KEY = :failed

    def self.reset(options = {})
      Sidekiq.redis { |c|
        c.multi do
          c.del(LIST_KEY)
          c.set('stat:failed', 0) if options[:counter] || options['counter']
        end
      }
    end
    def self.count
      Sidekiq.redis {|r| r.llen(LIST_KEY) }
    end
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Jfails::Middleware
  end
end

if defined?(Sidekiq::Web)
  Sidekiq::Web.register Sidekiq::Jfails::Web
  Sidekiq::Web.tabs['Job fails'] = 'jfails'
end
