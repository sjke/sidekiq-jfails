module Support
  class MockWorker
    include Sidekiq::Worker

    def perform(args)
		raise 'Test error'
    end
  end
end