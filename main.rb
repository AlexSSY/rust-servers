require_relative "domain"
require "dry/monads"

include Dry::Monads[:result]

def main
  open_meteo_weather_service = OpenMeteoWeatherService.new(
    latitude: ENV["LAT"],
    longitude: ENV["LON"]
  )

  result = open_meteo_weather_service.call

  case result
  in Success[weather_model]
    puts weather_model.to_h
  in Failure[error]
    puts error
  end
end

main
