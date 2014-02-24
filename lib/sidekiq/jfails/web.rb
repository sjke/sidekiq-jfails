module Sidekiq
  module Jfails
    module Web

      def self.registered(app)
        app.get '/jfails' do
          view_path = File.expand_path(File.dirname(__FILE__) + '/../../../web/views')

          @count = Sidekiq.fails_per_page
          (@current_page, @total_size, @fails) = page('failed', params[:page], @count)
          @fails = @fails.map { |msg| Sidekiq.load_json(msg) }
          render :erb, File.read(File.join(view_path, 'fails_list.erb'))
        end

        app.post '/jfails/reset' do
          Sidekiq::Jfails.reset(counter: params['counter'])
          redirect back
        end
      end
    end
  end
end