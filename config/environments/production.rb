Lita.configure do |config|
  # The name your robot will use.
  config.robot.name = 'PMDawn'

  # The locale code for the language to use.
  config.robot.locale = :en

  # The severity of messages to log. Options are:
  # :debug, :info, :warn, :error, :fatal
  # Messages at the selected level and above will be logged.
  config.robot.log_level = :info

  # An array of user IDs that are considered administrators. These users
  # the ability to add and remove other users from authorization groups.
  # What is considered a user ID will change depending on which adapter you use.
  # config.robot.admins = ["1", "2"]

  # The adapter you want to connect with. Make sure you've added the
  # appropriate gem to the Gemfile.
  # config.robot.adapter = :shell
  config.robot.adapter = :hipchat

  ## Example: Set options for the chosen adapter.
  # config.adapter.username = "myname"
  # config.adapter.password = "secret"

  ## Example: Set options for the Redis connection.
  config.redis.host = "127.0.0.1"
  config.redis.port = 6379

  ## Example: Set configuration for any loaded handlers. See the handler's
  ## documentation for options.
  # config.handlers.some_handler.some_config_key = "value"

  # Lita-Logger
  config.handlers.logger.log_file = "log/lita.log"

  # Lita-HipChat
  config.adapter.jid      = ENV['HIPCHAT_JID']
  config.adapter.password = ENV['HIPCHAT_PASSWORD']
  config.adapter.debug    = false
  config.adapter.rooms    = :all

end
