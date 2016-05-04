require 'yaml'

class Settings

  def self.config
    if Lita.env.development?
      hash = YAML.load_file('./config/application.yml')
      hash[Lita.env]
    else
      {
        hipchat: {
          jid: ENV['HIPCHAT_JID'],
          password: ENV['HIPCHAT_PASSWORD']
        },
        api: {
          url: ENV['API_URL'],
          key: ENV['API_KEY']
        },
        admins: [ ENV['ADMIN_ID'] ]
      }
    end
  end

end
