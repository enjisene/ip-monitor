# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require_relative '../config/boot'

require 'rspec'
require 'rack/test'
require 'database_cleaner/sequel'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner[:sequel].strategy = :transaction
    DatabaseCleaner[:sequel].clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner[:sequel].cleaning do
      example.run
    end
  end
end

def app
  App.freeze.app
end
