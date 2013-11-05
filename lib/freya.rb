require 'freya/version'
require 'active_support/core_ext/hash'
require 'yaml'
require 'rails'
require 'uri/mailto'

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
      name.to_s.split(' ').inject(self.class.config) { |result, n| result.fetch(n) }
    end
  end

  class Email < OpenStruct
    def link
      URI::MailTo.build({ to: to, headers: [
        ['subject', URI.escape(subject)], ['body', URI.escape(body)], *cc.map { |email| ['cc', email] }
      ] }).to_s
    end

    def body
      Template.new[name]
    end
  end
end