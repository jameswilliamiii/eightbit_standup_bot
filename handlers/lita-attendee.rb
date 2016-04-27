require 'date'

module Lita
  module Handlers
    class Attendee < Handler
      include ::Api
      include ::Common

      config :server

      route(/remove/, :destroy, command: true, help: { "remove" => "Remove yourself from this program's stand-ups", "remove NAME" => "Remove someone else from this program's stand-ups" })

      def destroy(response)
        @response = response
        sent_from_private_message(@response) and return if @response.room.nil?
        @username_array = @response.args
        url = build_uri(config.server, 'standups/delete_attendee', user_id(response))
        url << "&hipchat_room_name=#{@response.room.name}"
        url << "&attendees=#{@username_array.join(',')}" unless @username_array.empty?
        response = parse delete(url)
        msg = if response["success"]
          name = name_was_or_were
          "#{name} successfully removed from this chat room's stand-ups"
        elsif response["error"]
          response["error"]
        else
          name = you_or_name
          "Something went wrong, and I cannot remove #{name} from this chat room's stand-ups right now."
        end
        @response.reply_privately msg
      end

      private

      def name_was_or_were
        if @username_array.empty?
          'You were'
        elsif @username_array.count == 2
          "#{@username_array.join(' and ')} were"
        elsif @username_array.count > 2
          last = @username_array.last
          @username_array.pop
          str = "#{@username_array.join(', ')}"
          str << " and #{last} were"
          return str
        else
          "#{@username_array.first} was"
        end
      end

      def you_or_name
        @username_array.empty? ? 'you' : @username_array.join(', ')
      end

    end
    Lita.register_handler(Attendee)
  end
end