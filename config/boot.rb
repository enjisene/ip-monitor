# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'] || 'development')

require 'zeitwerk'

loader = Zeitwerk::Loader.new

loader.push_dir(File.expand_path('../app', __dir__))
loader.push_dir(File.expand_path('../app/contracts', __dir__))
loader.push_dir(File.expand_path('../app/models', __dir__))
loader.push_dir(File.expand_path('../app/services', __dir__))
loader.ignore(File.expand_path('../app/routes', __dir__))

loader.setup
require_relative 'database'
