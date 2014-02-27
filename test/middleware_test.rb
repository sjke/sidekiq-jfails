require 'test_helper'

module Sidekiq
  module Jfails
    describe 'Middleware' do

      before do
        Celluloid.boot
        @boss = MiniTest::Mock.new
        @processor = ::Sidekiq::Processor.new(@boss)

        Sidekiq.server_middleware {|chain| chain.add Sidekiq::Jfails::Middleware }
        Sidekiq.redis = REDIS
        Sidekiq.redis { |c| c.flushdb }
      end

      it 'defaults jfails_max_count to 10 000' do
        assert_equal 10000, Sidekiq.jfails_max_count
      end

      it 'defaults fails_per_page to 10' do
        assert_equal 10, Sidekiq.fails_per_page
      end

      it 'revert jfails_max_count by default when this set nil' do
        assert_equal 10000, Sidekiq.jfails_max_count

       	Sidekiq.jfails_max_count = 10
       	assert_equal 10, Sidekiq.jfails_max_count

		Sidekiq.jfails_max_count = nil
        assert_equal 10000, Sidekiq.failures_max_count 
      end

      it 'revert fails_per_page by default when this set nil' do
        assert_equal 10, Sidekiq.fails_per_page

       	Sidekiq.jfails_max_count = 1
       	assert_equal 1, Sidekiq.fails_per_page

		Sidekiq.jfails_max_count = nil
        assert_equal 10, Sidekiq.fails_per_page 
      end

      it 'records job fails by default jfails_max_count' do
        assert_equal 0, jfails_count

        msg = create_work('class' => MockWorker.to_s)

        10.times do
          actor_prepare
          assert_raises { @processor.process(msg) }
        end

        assert_equal 10, jfails_count
      end

      it 'removes old job fails when jfails_max_count has been reached' do
        assert_equal 0, jfails_count

		Sidekiq.jfails_max_count = 3

        msg = create_work('class' => MockWorker.to_s)
        10.times do
          actor_prepare
          assert_raises { @processor.process(msg) }
        end

        assert_equal 3, jfails_count
      end

      def actor_prepare
      	actor = MiniTest::Mock.new
        actor.expect(:processor_done, nil, [@processor])
        actor.expect(:real_thread, nil, [nil, Celluloid::Thread])
        2.times { @boss.expect(:async, actor, []) }
      end

      def create_work(msg)
        Sidekiq::BasicFetch::UnitOfWork.new('default', Sidekiq.dump_json(msg))
      end

      def jfails_count
        Sidekiq.redis { |redis| redis.llen('failed') } || 0
      end

      class MockWorker
	    include Sidekiq::Worker

	    def perform(args)
	      raise 'Test error'
		end
	  end
    end
  end
end