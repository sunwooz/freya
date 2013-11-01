require 'pigeon/version'
require 'active_support/core_ext/hash'
require 'yaml'
require 'rails'

module Pigeon
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
      name.to_s.split(' ').inject(self.class.config) { |result, n| result[n] }
    end
  end

  class Email < OpenStruct
    def link
      link = to + '?'

      link_params = ['subject', 'cc', 'body'].inject([]) do |link_params, param_name|
        param = send(param_name)
        link_params << param.to_query(param_name).gsub('+', '%20') if param
        link_params
      end

      link + link_params.join("&")
    end

    def body
      Template.new[name]
    end
  end
end