require 'freya/version'
require 'active_support/core_ext'
require 'yaml'
require 'rails'

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
      name.present? ? name.to_s.split(' ').inject(self.class.config) { |result, n| result.fetch(n) } : nil
    end
  end

  class Email
    attr_accessor :name, :to, :subject, :cc, :bcc

    def initialize(options = {})
      @name = options[:name]
      @to = options[:to]
      @subject = options[:subject]
      @cc = options[:cc] || []
      @bcc = options[:bcc] || []
    end

    def link
      extras = %w{ cc bcc body subject }.select { |extra| send(extra).present? }.map { |extra| [extra, send(extra)] }.map { |extra|
        name = extra[0]
        value = extra[1]

        #cc and  #bcc must be repeated for every email in the array
        [value].flatten.map do |component|
          "#{name}=#{Rack::Utils.escape_path(component)}"
        end
      }.compact

      extras = extras.empty? ? '' : '?' + extras.join('&')

      "#{to}#{extras}"
    end

    def body
      Template.new[name]
    end

    def cc
      @cc - [to]
    end

    def bcc
      @bcc - [to]
    end
  end
end