# frozen_string_literal: true

require 'spec_helper'

RSpec.describe IpContract do
  let(:contract) { subject }

  it 'is valid with correct IPv4' do
    expect(contract.call(ip: '8.8.8.8').success?).to be true
  end

  it 'is valid with correct IPv6' do
    expect(contract.call(ip: '2001:4860:4860::8888').success?).to be true
  end

  it 'is invalid with random string' do
    result = contract.call(ip: 'not-an-ip')
    expect(result.failure?).to be true
    expect(result.errors[:ip]).to include('is not a valid IPv4 or IPv6 address')
  end
end
