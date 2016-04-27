require 'json'

module Common
  extend ActiveSupport::Concern

  private

  def user_id(response)
    response.user.id
  end

  def sent_from_private_message(response)
    response.reply "This action must be performed in the the program's chat room, not by private message."
  end

end