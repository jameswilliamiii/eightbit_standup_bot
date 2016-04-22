require 'date'

module Lita
  module Handlers
    class Standup < Handler
      include ::Api

      config :server

      route(/^remind$/, :index, command: true, help: { "remind" => "Reminder of stand-ups required today." })

      def index(response)
        standups = [
          {'program_name' => 'Growit', 'remind_at' => '2016-04-22 17:46:08 -0500'},
          {'program_name' => 'Sushi Status', 'remind_at' => '2016-04-22 19:46:28 -0500'}
        ]
        if standups.any?
          stand_up_s = standups.count > 1 ? "stand-ups" : "stand-up"
          response.reply("You have #{standups.count} scheduled #{stand_up_s} for #{Date.today.strftime("%A")}:")
          standups.each_with_index do |standup, i|
            remind_at = Time.parse(standup['remind_at']).strftime("%l:%M %p")
            response.reply("#{i + 1}. #{standup['program']} should be submitted by #{remind_at}")
          end
        else
          response.reply('Booyah, you do not have any stand-ups due today. Go play some ping pong!')
        end
      end
    end
    Lita.register_handler(Standup)
  end
end