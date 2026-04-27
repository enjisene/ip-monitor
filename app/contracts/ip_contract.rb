# frozen_string_literal: true

require 'dry-validation'
require 'resolv'

class IpContract < Dry::Validation::Contract
  params do
    required(:ip).filled(:string)
    optional(:enabled).filled(:bool)
  end

  rule(:ip) do
    unless value.match?(Resolv::IPv4::Regex) || value.match?(Resolv::IPv6::Regex)
      key.failure('is not a valid IPv4 or IPv6 address')
    end
  end
end
