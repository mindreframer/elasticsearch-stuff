# Test environment
ENV['RACK_ENV'] = 'test'

require 'simplecov'

SimpleCov.start do
  # Filters
  add_filter "/spec"
  add_filter do |src|
    src.lines.count < 5
  end
  
  # Groups
  add_group "Lib", "/lib/icelastic"
  add_group "Middleware", "/lib/rack"
end

require "bundler/setup"
require 'rspec'
require 'rack/test'
require 'icelastic'

RSpec.configure do |conf|
  conf.include( Rack::Test::Methods )
end