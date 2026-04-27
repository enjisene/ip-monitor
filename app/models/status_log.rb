# frozen_string_literal: true

class StatusLog < Sequel::Model
  many_to_one :ip
end
