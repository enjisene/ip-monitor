# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StatisticsCalculator do
  let(:ip) { Ip.create(address: '127.0.0.1', enabled: true) }
  let(:now) { Time.now }

  it 'ignores checks made during disabled periods' do
    start_time = Time.now - 120
    ip = Ip.create(address: '127.0.0.1', enabled: true, created_at: start_time)

    ip.status_logs_dataset.update(changed_at: start_time)

    Check.create(ip_id: ip.id, rtt: 100, created_at: Time.now - 60)

    ip.add_status_log(enabled: false, changed_at: Time.now - 40)

    Check.create(ip_id: ip.id, rtt: 500, created_at: Time.now - 20)

    stats = StatisticsCalculator.call(ip, Time.now - 300, Time.now)

    expect(stats[:total_checks].to_i).to eq(1)
    expect(stats[:avg_rtt].to_f).to eq(100.0)
  end
end
