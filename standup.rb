# class Standup < Lita::Handler
#   config :server, default: 'testing', required: true

#   route(/^remind$/, :index, command: true, help: { "remind" => "Reminder of standups due today." })

#   def index(response)
#     debugger
#     standups = [
#       {'program' => 'Growit', 'due' => '10AM'},
#       {'program' => 'Sushi Status', 'due' => '12PM'}
#     ]
#     if standups.any?
#       response.reply("Your standups today: #{config.server}")
#       standups.each_with_index do |standup, i|
#         response.reply("#{i + 1}. #{standup['program']} should be submitted by #{standup['due']}")
#       end
#     else
#       response.reply('Booyah, you do not have any standups due today. Go play some ping pong!')
#     end
#   end

#   private

#   def get(url)
#     Net::HTTP.get make_uri(url)
#   end

#   def parse(obj)
#     MultiJson.load(obj)
#   end

#   def make_uri(url)
#     URI(url)
#   end
# end
