require 'rails_helper'

RSpec.describe WeathersController, type: :controller do
  describe 'GET #index' do
    context 'when the address is provided' do
      let(:address) { "Taj Mahal, Agra, India" }

      before do
        allow(WeatherService).to receive(:fetch_weather).with(address).and_return({
          temperature: 30,
          high: 35,
          low: 25,
          description: "Clear sky"
        })
        get :index, params: { address: address }
      end

      it 'assigns @address and renders template' do
        expect(assigns(:address)).to eq(address)
        expect(response).to render_template(:index)
      end

      it 'assigns @weather_data with the correct weather information' do
        expect(assigns(:weather_data)).to eq({
          temperature: 30,
          high: 35,
          low: 25,
          description: "Clear sky"
        })
      end
    end

    context 'when the address is not found or invalid' do
      let(:address) { "Nonexistent address" }

      before do
        # Mock the response to return nil when the address is invalid
        allow(WeatherService).to receive(:fetch_weather).with(address).and_return(nil)
        get :index, params: { address: address }
      end

      it 'assigns @address' do
        expect(assigns(:address)).to eq(address)
      end

      it 'assigns @weather_data as nil and sets a flash error message' do
        expect(assigns(:weather_data)).to be_nil
        expect(flash[:error]).to eq("Couldn't retrieve weather data for the address.")
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
  end
end
