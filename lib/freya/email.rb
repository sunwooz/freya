require 'freya'

module Freya
  class Email < OpenStruct
    def link
      params = params_mapping.select { |param_name, url_param_name| send(param_name).present? }.map do |param_name, url_param_name|
        [send(param_name)].flatten.map do |param|
          "#{url_param_name}=#{Rack::Utils.escape_path(param)}"
        end
      end.compact

      base_url + '?' + (params + extra_params).join('&')
    end

    def body
      Template.new[name]
    end

    def cc
      ([base_cc].flatten + [self[:cc]].flatten - [to]).compact.uniq
    end

    def bcc
      ([base_bcc].flatten + [self[:bcc]].flatten - [to]).compact.uniq
    end

    private

    def param_names
      %w(cc bcc body subject)
    end

    def params_mapping
      param_names.inject({}) { |params, param| params[param] = param; params }
    end

    def base_url
      to
    end

    def extra_params
      []
    end
  end
end