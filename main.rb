require_relative "data"

def main
  data_source = OpenMeteoSource.new(
    location: Location.new(latitude: "33.94535964189262", longitude: "50.204589444188336")
  )

  data_source&.then { |ds|
    puts ds.today
  }
end

main
