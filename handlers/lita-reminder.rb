require 'date'

module Lita
  module Handlers
    class Reminder < Handler
      include ::Api
      include ::Common

      config :server

      route(/remind/i, :index, command: true, help: { "remind" => "Reminder of stand-ups required today." })
      http.post("/reminder-hook", :receive_reminder_hook)

      def index(response)
        @response = response
        url = build_uri(config.server, 'standups', user_id(@response))
        url << "&hipchat_username=#{@response.user.name}"
        standups = parse get(url)
        if standups.any?
          @response.reply_privately(build_summary(standups))
          standups.each_with_index do |standup, i|
            remind_at = build_remind_at(standup)
            number = build_number(standups, i)
            @response.reply_privately("#{number}#{standup['program_name']} should be submitted by #{remind_at}")
          end
        else
          @response.reply_privately("Booyah, you do not have any stand-ups to worry about right now. #{find_activity}")
        end
      end

      def receive_reminder_hook(request, response)
        body = MultiJson.load(request.body)
        if body["attendees"]
          body["attendees"].each do |user|
            source = lita_source(user['hipchat_id'])
            robot.send_message(source, "Just a kind reminder from your favorite PM that a #{user['program_name']} stand-up is due today :)")
          end
        end
        response.status = 202
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

      def find_activity
        arr = [
          'Go play some (pingpong)!',
          'Go play some bubble hockey!',
          "Enjoy some M&M's with Jennifer!",
          'Give yourself a high five'
        ]
        arr.sample(1).first
      end

      def lita_source(hipchat_id)
        user = Lita::User.new(hipchat_id)
        Lita::Source.new(user: user)
      end

    end
    Lita.register_handler(Reminder)
  end
end