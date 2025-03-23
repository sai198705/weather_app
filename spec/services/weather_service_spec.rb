require 'rails_helper'
require 'httparty'

RSpec.describe WeatherService, type: :service do
  describe '.fetch_weather' do
    let(:address) { "Taj Mahal, Agra, India" }
    let(:lat) { 27.1751 }
    let(:lon) { 78.0421 }
    let(:parsed_response_body) { {'main' => { 'temp' => 30, 'temp_max' => 35, 'temp_min' => 25 },
            'weather' => [{ 'description' => 'Clear sky' }]
          } }

    let(:weather_data) do 
      {
        description: 'clear sky', 
        high: 33.85,
        low: 33.85,
        temperature: 33.85
      }
    end

    context 'when the address is valid and weather data is fetched successfully' do
      before do
        allow(Geocoder).to receive(:search).with(address).and_return([OpenStruct.new(latitude: lat, longitude: lon)])
        api_response =  instance_double(HTTParty::Response, response: parsed_response_body )
        allow(api_response).to receive(:success?).and_return(true)
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
