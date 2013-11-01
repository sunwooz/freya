require 'pigeon/version'
require 'active_support/core_ext/hash'
require 'yaml'
require 'rails'

module Pigeon
  class Template
    def initialize
      @@config ||= HashWithIndifferentAccess.new(YAML.load(IO.read(File.join(Rails.root, 'config', 'emails.yml'))))
    end

    def [](name)
      name.to_s.split(' ').inject(@@config) { |result, n| result[n] }
    end
  end

  class Email < OpenStruct
    def link
      link = [to + '?' + subject.to_query('subject').gsub('+', '%20')]
      link << cc.to_query('cc').gsub('+', '%20') if cc
      link << body.to_query('body').gsub('+', '%20')
      link.join("&")
    end

    def body
      Template.new[name]
    end
  end
end