class WeathersController < ApplicationController
  def index
    if params[:address].present?
      @address = params[:address]
      @weather_data = WeatherService.fetch_weather(@address)
      
      if @weather_data.nil?
        flash[:error] = "Couldn't retrieve weather data for the address."
      end
    end
  end
end
