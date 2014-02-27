require "minitest/autorun"
require "minitest/spec"
require "minitest/mock"

require "rack/test"

require "sidekiq"
require "sidekiq-jfails"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

Sidekiq.logger = nil
REDIS = Sidekiq::RedisConnection.create(:url => "redis://localhost/15", :namespace => 'sidekiq_extension_test')