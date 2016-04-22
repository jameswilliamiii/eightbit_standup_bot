require 'date'

module Lita
  module Handlers
    class Standup < Handler
      config :server

      route(/^remind$/, :index, command: true, help: { "remind" => "Reminder of stand-ups required today." })

      def index(response)
        standups = [
          {'program' => 'Growit', 'due' => '10AM'},
          {'program' => 'Sushi Status', 'due' => '12PM'}
        ]
        if standups.any?
          stand_up_s = standups.count > 1 ? "stand-ups" : "stand-up"
          response.reply("You have #{standups.count} scheduled #{stand_up_s} for #{Date.today.strftime("%A")}:")
          standups.each_with_index do |standup, i|
            response.reply("#{i + 1}. #{standup['program']} should be submitted by #{standup['due']}")
          end
        else
          response.reply('Booyah, you do not have any stand-ups due today. Go play some ping pong!')
        end
      end

      private

      def get(url)
        Net::HTTP.get make_uri(url)
      end

      def parse(obj)
        MultiJson.load(obj)
      end

      def make_uri(url)
        URI(url)
      end
    end
    Lita.register_handler(Standup)
  end
end