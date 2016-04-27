module Lita
  module Handlers
    class Standup < Handler
      include ::Api

      config :server

      route(/standup|stand-up/, :create, command: true, help: { "standup or stand-up" => "Create a new status update for your team." })

      def create(response)
        @response = response
        private_message and return if @response.room.nil?
        empty_message and return if response_is_empty?
        id = @response.user.id
        url = build_uri(config.server, 'status_updates', id)
        url << "&hipchat_room_name=#{@response.room.name}"
        body = {status: @response.message.body}
        api_response = parse post(url, body)
        if api_response["success"]
          @response.reply("(thumbsup) Your stand-up has been recorded")
        elsif api_response["error"]
          @response.reply api_response["error"]
        else
          @response.reply "Oops, something went awry and I was unable to record your stand-up :( "
        end
      end

      private

      def private_message
        @response.reply "New stand-ups need to be given in the the program's chat room, not by private message."
      end

      def empty_message
        @response.reply "I did not detect any content to create your stand-up."
      end

      def response_is_empty?
        cleaned_response = @response.message.body.downcase.gsub(/standup|stand-up/, '')
        cleaned_response.empty?
      end

    end
    Lita.register_handler(Standup)
  end
end