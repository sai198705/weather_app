require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "should get forecast" do
    get weather_forecast_url
    assert_response :success
  end
end
