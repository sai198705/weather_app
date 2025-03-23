require 'rails_helper'
require 'httparty'

RSpec.describe WeatherService, type: :service do
  describe '.fetch_weather' do
    let(:address) { "Taj Mahal, Agra, India" }
    let(:lat) { 27.1751 }
    let(:lon) { 78.0421 }
    let(:parsed_response_body) do
      {
        "coord" => { "lon" => lon, "lat" => lat },
        "weather" => [{ "id" => 701, "main" => "Mist", "description" => "mist", "icon" => "50d" }],
        "base" => "stations",
        "main" => { "temp" => 12.56, "feels_like" => 12.14, "temp_min" => 11.5, "temp_max" => 14.12, "pressure" => 1003, "humidity" => 87 },
        "visibility" => 10000,
        "wind" => { "speed" => 2.57, "deg" => 20 },
        "clouds" => { "all" => 75 },
        "dt" => 1742727466,
        "sys" => { "type" => 2, "id" => 2091269, "country" => "GB", "sunrise" => 1742709376, "sunset" => 1742753879 },
        "timezone" => 0,
        "id" => 2640692,
        "name" => "Paddington",
        "cod" => 200
      }
    end
    let(:weather_data) do 
      {
        temperature: 12.56, 
        high: 14.12,
        low: 11.5,
        description: 'mist' 
      }
    end

    context 'when the address is valid and weather data is fetched successfully' do
      before do
        allow(Geocoder).to receive(:search).with(address).and_return([OpenStruct.new(latitude: lat, longitude: lon)])
        api_response = instance_double(HTTParty::Response, success?: true, parsed_response: parsed_response_body)
        allow(HTTParty).to receive(:get).and_return(api_response)
      end

      it 'returns the correct weather data' do
        result = WeatherService.fetch_weather(address)
        expect(result).to eq(weather_data)
      end
    end

    context 'when the weather API request fails' do
      before do
        allow(HTTParty).to receive(:get).and_return(double(success?: false))
      end

      it 'returns nil' do
        result = WeatherService.fetch_weather(address)

        expect(result).to be_nil
      end
    end

    context 'when Geocoder cannot find the address' do
      before do
        allow(Geocoder).to receive(:search).with(address).and_return([])
      end

      it 'returns nil' do
        result = WeatherService.fetch_weather(address)

        expect(result).to be_nil
      end
    end
  end
end
