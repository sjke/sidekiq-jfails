require 'test_helper'

module Sidekiq
  module Jfails
    describe Middleware do

      describe 'Settings' do
	    it 'defaults jfails_max_count to 10 000' do
	      assert_equal 10000, Sidekiq.jfails_max_count
	    end

	    it 'defaults fails_per_page to 10' do
	      assert_equal 10, Sidekiq.fails_per_page
	    end

	    it 'revert jfails_max_count by default when this set nil' do
	      assert_equal 10000, Sidekiq.jfails_max_count

	      Sidekiq.jfails_max_count= 10
	      assert_equal 10, Sidekiq.jfails_max_count

		  Sidekiq.jfails_max_count= nil
	      assert_equal 10000, Sidekiq.jfails_max_count 
	    end

	    it 'revert fails_per_page by default when this set nil' do
	      assert_equal 10, Sidekiq.fails_per_page

	      Sidekiq.fails_per_page= 1
	      assert_equal 1, Sidekiq.fails_per_page

		  Sidekiq.fails_per_page= nil
	      assert_equal 10, Sidekiq.fails_per_page 
	    end
	  end

	  describe 'Recording' do
	  	WorkerException = Class.new(Exception)

	  	let(:msg)    { {'class' => 'MockWorker', 'args' => ['custom_argument'], 'retry' => false} }
      	let(:handler){ Sidekiq::Jfails::Middleware.new }

        before do
	      Sidekiq.redis = REDIS
	      Sidekiq.redis { |c| c.flushdb }
	    end
	    it 'records job fails by default jfails_max_count' do
	      assert_equal 0, jfails_count
          
          10.times do
	        assert_raises WorkerException do
	       	  handler.call(MockWorker.new, msg, 'default') do
	          	raise WorkerException.new 'test'
	          end
	        end
	      end

	      assert_equal 10, jfails_count
	    end

	    it 'removes old job fails when jfails_max_count has been reached' do
	      assert_equal 0, jfails_count
	 	  Sidekiq.jfails_max_count= 3
	      
	      10.times do
	        assert_raises WorkerException do
	          handler.call(MockWorker.new, msg, 'default') do
	          	raise WorkerException.new 'test'
	          end
	        end
	      end

	      assert_equal 3, jfails_count
	      Sidekiq.jfails_max_count= nil
	    end

	    def jfails_count
	      Sidekiq.redis { |redis| redis.llen('failed') } || 0
	    end

	    class MockWorker
		  include Sidekiq::Worker
          
          def perform
		  end
		end
	  end
    end
  end
end