module Sidekiq
  module Jfails
    class Middleware
      include Sidekiq::Util
      attr_accessor :msg

      def call(worker, msg, queue)
        self.msg = msg
        yield
      rescue Exception => e
        data = {
            :date => Time.now.utc,
            :exception => e.class.to_s,
            :args => msg['args'],#.join(', '),
            :error => e.message,
            :backtrace => e.backtrace,
            :worker => msg['class'],
            :queue => queue
        }

        Sidekiq.redis do |conn|
          conn.lpush(LIST_KEY, Sidekiq.dump_json(data))
          conn.ltrim(LIST_KEY, 0, Sidekiq.jfails_max_count - 1) unless Sidekiq.jfails_max_count == 0
        end

        raise e
      end
    end
  end
end
