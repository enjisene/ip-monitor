# frozen_string_literal: true

require_relative 'config/boot'
require 'rufus-scheduler'
require 'concurrent-ruby'

scheduler = Rufus::Scheduler.new
executor = Concurrent::FixedThreadPool.new(20)

puts 'Monitoring service started...'

scheduler.every "#{ENV.fetch('MONITORING_INTERVAL', 60)}s", mutex: 'ip_check' do
  start_time = Time.now
  active_ips = Ip.where(enabled: true).all

  puts "[#{start_time}] Starting check for #{active_ips.count} addresses"

  promises = active_ips.map do |ip|
    Concurrent::Promise.execute(executor: executor) do
      rtt = Pinger.call(ip.address.to_s)

      Check.create(
        ip_id: ip.id,
        rtt: rtt,
        created_at: Time.now
      )
    end
  end

  Concurrent::Promise.zip(*promises)

  duration = Time.now - start_time
  puts "[#{Time.now}] Check completed in #{duration.round(2)}s"
end

scheduler.join
