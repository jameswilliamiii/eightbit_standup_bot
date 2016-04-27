require 'date'

module Lita
  module Handlers
    class Standup < Handler
      include ::Api

      config :server

      route(/standup|stand-up/, :create, command: true, help: { "standup or stand-up" => "Create a new status update for your team." })
      route(/list/, :index, command: true, help: { "list" => "List all stand-ups submitted today.", "list MM/DD/YYYY" => "List all stand-ups submitted on a specific date." })

      def index(response)
        @response = response
        sent_from_private_message and return if @response.room.nil?
        url = build_uri(config.server, 'status_updates', user_id)
        url << "&hipchat_room_name=#{@response.room.name}&hipchat_username=#{@response.user.name}"
        @date = valid_date @response.message.body
        url << "&date=#{@date}" if @date
        status_updates = parse get(url)
        if status_updates.any?
          status_updates.each do |status_update|
            status_update.each do |attendee, statuses|
              msg = "#{attendee}: \n"
              statuses.each do |status|
                msg << "#{status["status"]} \n"
              end
              msg << "\n"
              response.reply_privately msg
            end
          end
        else
          no_status_updates
        end
      end

      def create(response)
        @response = response
        sent_from_private_message and return if @response.room.nil?
        empty_message and return if response_is_empty?
        url = build_uri(config.server, 'status_updates', user_id)
        url << "&hipchat_room_name=#{@response.room.name}&hipchat_username=#{@response.user.name}"
        body = {status: @response.message.body}
        api_response = parse post(url, body)
        if api_response["success"]
          @response.reply_privately("(thumbsup) Your stand-up has been recorded")
        elsif api_response["error"]
          @response.reply_privately api_response["error"]
        else
          @response.reply_privately "Oops, something went awry and I was unable to record your stand-up :( "
        end
      end

      private

      def user_id
        @response.user.id
      end

      def valid_date( str, format="%m/%d/%Y" )
        Date.strptime(str,format) rescue false
      end

      def build_summary(status_updates)
        update_s = status_updates.count > 1 ? "updates" : "update"
        "You have #{status_updates.count} stand-up status #{update_s} submitted #{status_updates.first.created_at.strftime("%a %b %e, %Y")}:"
      end

      def sent_from_private_message
        @response.reply "This action must be performed in the the program's chat room, not by private message."
      end

      def empty_message
        @response.reply_privately "I did not detect any content to create your stand-up."
      end

      def response_is_empty?
        cleaned_response = @response.message.body.downcase.gsub(/standup|stand-up/, '')
        cleaned_response.empty?
      end

      def no_status_updates
        msg = 'Sorry, I could not find any status updates for'
        if @date
          msg << " #{@response.message.body.gsub('list', '')}."
        else
          msg << " today."
        end
        @response.reply_privately msg
      end

    end
    Lita.register_handler(Standup)
  end
end