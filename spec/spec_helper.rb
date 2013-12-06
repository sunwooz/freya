require 'freya'
require 'pry'

def reload_template
  Freya.send(:remove_const, 'Template')
  load 'lib/freya/template.rb'
end

RSpec.configure do |config|
  config.before(:each) do
    File.stub(exists?: true)
    Rails.stub(root: 'freya')
    reload_template
  end
end