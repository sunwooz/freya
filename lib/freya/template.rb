require 'freya'
require 'yaml'
require 'rails'
require 'active_support/core_ext'

module Freya
  class Template
    def self.config=(config)
      @config ||= config
    end

    def self.config
      @config
    end

    def initialize
      return unless File.exists?(File.join(Rails.root, 'config', 'emails.yml'))
      self.class.config ||= HashWithIndifferentAccess.new(YAML.load(IO.read(File.join(Rails.root, 'config', 'emails.yml'))))
    end

    def [](name)
      name.present? ? name.to_s.split('.').inject(self.class.config) { |result, n| result.fetch(n) } : nil
    end
  end
end