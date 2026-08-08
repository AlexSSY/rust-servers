require "dry-initializer"
require "dry-struct"
require 'dotenv/load'
require_relative "domain"

Types = Dry.Types()

class Location < Dry::Struct
  attribute :latitude, Types::String
  attribute :longitude, Types::String
end

class WeatherDataSource
  extend Dry::Initializer

  param :location

  def today
    raise NotImplementedError
  end
end

class WeatherInfoDto < Dry::Struct
  attribute :city_name, Types::String
  attribute :temparature, Types::String

  def to_domain
    RustServerModel.new(name:, online:)
  end
end

class OpenMeteoSource < WeatherDataSource
  def today
  end

  private

  def api_key
    ENV["OPEN_WEATHER_API_KEY"]
  end
end
