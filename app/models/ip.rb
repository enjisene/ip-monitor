# frozen_string_literal: true

class Ip < Sequel::Model
  one_to_many :checks
  one_to_many :status_logs

  def active?
    enabled
  end

  def after_create
    super
    add_status_log(enabled: enabled, changed_at: created_at)
  end
end
