require "minitest/autorun"
require "minitest/spec"
require "minitest/mock"

require "rack/test"

require "celluloid"
require "sidekiq"
require "sidekiq-failures"
require "sidekiq/processor"
require "sidekiq/fetch"
require "sidekiq/cli"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

Celluloid.logger = Logger::ERROR
Sidekiq.logger.level = Logger::ERROR
REDIS = Sidekiq::RedisConnection.create(:url => "redis://localhost/15", :namespace => 'sidekiq_extension_test')