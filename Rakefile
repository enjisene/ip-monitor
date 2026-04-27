# frozen_string_literal: true

require_relative 'config/boot'

namespace :db do
  desc 'Run migrations'
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(DB.connection, 'db/migrations')
    puts 'Successfully migrated!'
  end
end
