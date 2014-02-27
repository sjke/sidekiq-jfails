require 'test_helper'

module Sidekiq
  describe Jfails do

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
end