# frozen_string_literal: true

require 'sequel'

require 'dotenv/load' if ENV['RACK_ENV'] == 'development'

module DB
  def self.connection
    @connection ||= Sequel.connect(ENV.fetch('DATABASE_URL'))
  end
end

DB.connection.extension :pg_array, :pg_json, :pagination
Sequel::Model.plugin :timestamps, update_on_create: true
