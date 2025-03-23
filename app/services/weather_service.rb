class WeatherService
  def self.fetch_weather(address)
    location = Geocoder.search(address).first
    return nil unless location

    lat = location.latitude
    lon = location.longitude

    api_key = ENV['OPENWEATHER_API_KEY']
    url = "#{WEATHER_API_URL}?lat=#{lat}&lon=#{lon}&appid=#{WEATHER_API_KEY}&units=metric"
    response = HTTParty.get(url)

    if response.success?
      {
        temperature: response.parsed_response['main']['temp'],
        high: response.parsed_response['main']['temp_max'],
        low: response.parsed_response['main']['temp_min'],
        description: response.parsed_response['weather'].first['description']
      }
    else
      nil
    end
  end
end
