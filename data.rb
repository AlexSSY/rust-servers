require "dry-initializer"
require "dry-struct"
require 'dotenv/load'
require "net/http"
require "uri"
require_relative "domain"

Types = Dry.Types()

class WeatherDataSource
  extend Dry::Initializer
  param :location
end

class OpenMeteoDto < Dry::Struct
  attribute :city_name, Types::String
  attribute :temperature, Types::String

  def to_domain
    RustServerModel.new(name:, online:)
  end
end

class OpenMeteoDS < WeatherDataSource
  def today
    uri = URI::HTTPS.open
    Net::HTTP.get("https://google.com/")
  end

  private

  def api_key
    ENV["OPEN_WEATHER_API_KEY"]
  end
end
