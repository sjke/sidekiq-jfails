require "test_helper"
require "sidekiq/web"

module Sidekiq
  describe Web do
    include Rack::Test::Methods

    def app
      Sidekiq::Web
    end

    before do
      Sidekiq.redis = REDIS
      Sidekiq.redis {|c| c.flushdb }
    end

    it 'can display Job fails tab' do
      get '/'

      last_response.status.must_equal 200
      last_response.body.must_match /Sidekiq/
      last_response.body.must_match /Job fails/
    end

    it 'can display Job fails page without fails' do
      get '/jfails'
      last_response.status.must_equal 200
      last_response.body.must_match /Job fails/
      last_response.body.must_match /No failed jobs found/
    end

    describe 'when there are fails' do
      before do
        create_sample_fail
        get '/jfails'
      end

      it 'can display Job fails page with fails listed' do	
        last_response.body.wont_match /No failed jobs found/
        last_response.body.must_match /HardWorker/
        last_response.body.must_match /ArgumentError: Some new message/
        last_response.body.must_match /default/
        last_response.body.must_match /bob, 5/
      end

      it 'can remove all Job fails' do
        assert_equal failed_count, "1"

        last_response.body.must_match /HardWorker/

        post '/jfails/reset', counter: "true"
        last_response.status.must_equal 302

        get '/jfails'
        last_response.status.must_equal 200
        last_response.body.must_match /No failed jobs found/

        assert_equal failed_count, "0"
      end
    end

    def create_sample_fail
      data = {
        :date => Time.now.strftime("%Y/%m/%d %H:%M:%S %Z"),
        :args => ["bob", 5].join(', '),
        :exception => "ArgumentError",
        :error => "Some new message",
        :backtrace => ["path/file1.rb", "path/file2.rb"],
        :worker => 'HardWorker',
        :queue => 'default'
      }

      Sidekiq.redis do |c|
        c.multi do
          c.rpush("failed", Sidekiq.dump_json(data))
          c.set("stat:failed", 1)
        end
      end
    end

    def failed_count
      Sidekiq.redis { |c| c.get("stat:failed") }
    end
  end
end