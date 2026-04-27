# frozen_string_literal: true

class Check < Sequel::Model
  many_to_one :ip
end
