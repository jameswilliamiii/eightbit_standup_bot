require 'lita'
require 'active_support'
require 'active_support/core_ext/module/aliasing'

module Lita
  class << self
    def env
      @env ||= ActiveSupport::StringInquirer.new(ENV['LITA_ENV'] || 'development')
    end

    def root
      @root ||= ENV['LITA_ROOT'] ||= File.expand_path('.')
    end
  end
end