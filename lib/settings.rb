require 'yaml'

class Settings

  def self.config
    hash = YAML.load_file('./config/application.yml')
    hash[Lita.env]
  end

end
