# frozen_string_literal: true

require 'net/ping'

class Pinger
  TIMEOUT = 1

  def self.call(ip_address)
    pinger = Net::Ping::External.new(ip_address, timeout: TIMEOUT)

    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    if pinger.ping?
      end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      (end_time - start_time) * 1000
    end
  rescue StandardError => e
    puts e
    nil
  end
end
