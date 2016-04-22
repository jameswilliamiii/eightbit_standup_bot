require 'date'

module Lita
  module Handlers
    class Standup < Handler
      include ::Api

      config :server

      route(/^remind$/, :index, command: true, help: { "remind" => "Reminder of stand-ups required today." })
      route(/standup/i, :create, command: true, help: { "standup program_name" => "Create a new status update for your PM." })

      def index(response)
        id = response.user.id
        url = build_uri(config.server, 'standups', id)
        standups = parse get(url)
        if standups.any?

          response.reply(build_summary(standups))

          standups.each_with_index do |standup, i|
            remind_at = build_remind_at(standup)
            number = build_number(standups, i)

            response.reply("#{number}#{standup['program_name']} should be submitted by #{remind_at}")

          end
        else
          response.reply('Booyah, you do not have any stand-ups due today. Go play some ping pong!')
        end
      end

      def create(response)
        response.reply("It Worked!")
      end

      private

      def build_summary(standups)
        stand_up_s = standups.count > 1 ? "stand-ups" : "stand-up"
        "You have #{standups.count} scheduled #{stand_up_s} for #{Date.today.strftime("%A")}:"
      end

      def build_remind_at(standup)
        Time.parse(standup['remind_at']).strftime("%l:%M %p")
      end

      def build_number(standups, i)
        number = if standups.count > 1
          "#{i + 1}. "
        else
          ''
        end
      end

    end
    Lita.register_handler(Standup)
  end
end