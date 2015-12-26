require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require File.expand_path '../../lib/txt_server', __FILE__
require File.expand_path '../api_helpers.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() described_class end
end

RSpec.configure do |c| 
  c.include RSpecMixin 
  c.include ApiHelpers
end
