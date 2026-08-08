require "dry/initializer"
require "dry/operation"
require "dry/struct"

require "uri"
require "open-uri"
require "json"

Types = Dry.Types()

class WeatherModel < Dry::Struct
  attribute :city, Types::String
end

class OpenMeteoWeatherService < Dry::Operation
  extend Dry::Initializer

  option :latitude
  option :longitude

  def call
    json_hash = step response(api_uri)
    city = step city_name(json_hash)
    WeatherModel.new(city:)
  end

  def city_name(json_hash)
    city = json_hash.fetch("city")
    city ? Success(city) : Failure("City not found")
  end

  def response(uri)
    begin
      response = URI.open(uri)
      return Success(JSON.parse(response.read))
    rescue OpenURI::HTTPError => e
      status = e.io.status[0]  # e.g., "404"
      message = e.io.status[1] # e.g., "Not Found"
      return Failure("HTTP Error encountered: Code #{status} - #{message}")
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      return Failure("Timeout Error: The server took too long to respond. (#{e.message}")
    rescue SocketError => e
      return Failure("Network Error: Could not resolve host or no network access. (#{e.message})")
    rescue StandardError => e
      return Failure("An unexpected error occurred: #{e.class} - #{e.message}")
    end
  end

  private

  def api_uri
    URI.parse("https://api.bigdatacloud.net/data/reverse-geocode-client").tap do |uri|
      search_params = [
        ["latitude", latitude],
        ["longitude", longitude],
        ["localityLanguage", "uk"]
      ]
      query_array = URI.decode_www_form(uri.query || '') + search_params
      uri.query = URI.encode_www_form(query_array)
      uri
    end
  end
end
