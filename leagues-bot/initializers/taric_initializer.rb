# Request dependencies
require 'taric'
require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

# Config API Key for Taric
Taric.configure! do |config|
  config.api_key = '<RIOT_api_key'>
  config.adapter = :typhoeus # default is Faraday.default_adapter
end

# A Summoner has reconnected
@taric = Taric.client(region: :lan) # Info about regions at Taric Github <3
