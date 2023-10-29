# frozen_string_literal: true

require 'test_helper'

class WeatherControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_address = '123 Main Street'
    @invalid_address = 'invalid'

    # Mock Reading object
    @mock_reading = Reading.create(
      zipcode: '12345',
      temp: 20.0,
      temp_min: 18.0,
      temp_max: 22.0,
      icon: '01d',
      main: 'Clear',
      description: 'clear sky',
      wind: 5.0,
      wind_direction: 100
    )
    @error_message = 'Error fetching weather'
  end

  test 'should get index' do
    get weather_index_url
    assert_response :success
    assert_select 'form' # Check if the form is rendered
  end

  test 'should display weather for a valid address' do
    Weather.any_instance.stubs(:current).returns(@mock_reading)

    get weather_index_url, params: { address: @valid_address }
    assert_response :success
    assert_select 'div', @mock_reading[:zipcode]
  end

  test 'should handle errors from weather service' do
    Weather.any_instance.stubs(:current).raises(StandardError.new(@error_message))

    get weather_index_url, params: { address: @invalid_address }
    assert_response :success
    assert_select 'div.bg-red-500', text: @error_message
  end
end
