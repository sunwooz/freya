require 'freya'

module Freya
  class Gmail < Email
    private

    def param_names
      super << 'to'
    end

    def params_mapping
      super.merge({'subject' => 'su'})
    end

    def base_url
      'https://mail.google.com/mail'
    end

    def extra_params
      ['view=cm', 'fs=1']
    end
  end
end