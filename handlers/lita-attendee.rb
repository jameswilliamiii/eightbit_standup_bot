require 'date'

module Lita
  module Handlers
    class Attendee < Handler
      include ::Api

      config :server

      route(/remove/, :destory, command: true, help: { "remove" => "Remove yourself from this program's stand-ups", "remove NAME" => "Remove someone else from this program's stand-ups" })

      def destroy(response)
        @response = response
        sent_from_private_message and return if @response.room.nil?
        url = build_uri(config.server, 'remove_attendee', user_id)
        url << "&hipchat_room_name=#{@response.room.name}&hipchat_username=#{@response.user.name}"
      end

      private

      def user_id
        @response.user.id
      end

      def sent_from_private_message
        @response.reply "This action must be performed in the the program's chat room, not by private message."
      end

    end
    Lita.register_handler(Attendee)
  end
end