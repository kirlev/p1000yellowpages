require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require_relative '../p1000_yellow_pages'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
    config.include RSpecMixin 
    config.add_setting :datastore
    config.datastore = DATASTORE
end