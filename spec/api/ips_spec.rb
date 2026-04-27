# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'IP Monitor API' do
  describe 'POST /ips' do
    it 'creates a new IP and returns 200' do
      post '/ips', { ip: '1.1.1.1', enabled: true }.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json['address']).to eq('1.1.1.1')

      expect(Ip.where(address: '1.1.1.1').count).to eq(1)
    end
  end

  describe 'GET /ips/:id/stats' do
    let!(:ip) { Ip.create(address: '1.0.0.1', enabled: true, created_at: Time.now - 3600) }

    it 'returns stats when data exists' do
      Check.create(ip_id: ip.id, rtt: 10.5, created_at: Time.now - 300)
      Check.create(ip_id: ip.id, rtt: 15.5, created_at: Time.now - 200)

      ip.add_status_log(enabled: true, changed_at: Time.now - 3600)

      get "/ips/#{ip.id}/stats", {
        time_from: (Time.now - 600).iso8601,
        time_to: Time.now.iso8601
      }

      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json['avg_rtt']).to eq(13.0)
    end
  end
end
