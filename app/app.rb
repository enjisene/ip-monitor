# frozen_string_literal: true

class App < Roda
  plugin :json
  plugin :json_parser
  plugin :all_verbs
  plugin :halt
  plugin :hash_branches

  Dir[File.join(__dir__, 'routes', '*.rb')].sort.each { |f| require f }

  route do |r|
    r.hash_branches

    r.root do
      { status: 'ok', service: 'IP Monitor' }
    end
  end
end
