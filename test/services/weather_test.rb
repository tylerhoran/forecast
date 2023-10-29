# frozen_string_literal: true

require 'test_helper'
require 'mocha/minitest'

class WeatherTest < ActiveSupport::TestCase
  def setup
    @address = '123 Main St'
    @weather = Weather.new(@address)
    @zipcode = '12345'
    @weather_client = OpenWeather::Client.new(api_key: 'test_api_key')
    @weather.instance_variable_set(:@weather_client, @weather_client)
  end

  def test_initialization
    assert_equal @address, @weather.instance_variable_get(:@address)
  end

  def test_current_with_valid_cached_reading
    cached_reading_mock = mock
    cached_reading_mock.stubs(:cached=)
    cached_reading_mock.stubs(:cached).returns(true)
    cached_reading_mock.stubs(:created_within?).returns(true)

    Reading.expects(:find_recent_by_zipcode).with(@zipcode).returns(cached_reading_mock)
    AddressGeocoder.expects(:geocode).with(@address).returns(@zipcode)

    @weather.current
    assert_equal true, cached_reading_mock.cached
  end

  def test_current_with_invalid_cached_reading
    Reading.expects(:find_recent_by_zipcode).with(@zipcode).returns(stub(created_within?: false))
    @weather.expects(:fetch_and_cache_new_reading).returns(Reading.new)
    AddressGeocoder.expects(:geocode).with(@address).returns(@zipcode)
    assert @weather.current
  end

  def test_current_with_geocoder_error
    AddressGeocoder.expects(:geocode).with(@address).raises('Invalid Address')
    assert_raises(RuntimeError) { @weather.current }
  end

  def test_current_with_weather_client_error
    Reading.expects(:find_recent_by_zipcode).with(@zipcode).returns(nil)
    AddressGeocoder.expects(:geocode).with(@address).returns(@zipcode)
    @weather_client.expects(:current_weather).with(zip: @zipcode, units: 'metric').raises(Faraday::ResourceNotFound)
    assert_raises(RuntimeError) { @weather.current }
  end

  def test_current_with_geocode_error
    AddressGeocoder.expects(:geocode).with(@address).raises('Invalid Address')
    assert_raises(RuntimeError, 'Invalid Address') { @weather.current }
  end

  def test_current_with_new_reading_fetched_and_cached
    AddressGeocoder.expects(:geocode).with(@address).returns(@zipcode)
    Reading.expects(:find_recent_by_zipcode).with(@zipcode).returns(nil)

    new_reading_data = { temp: 20, temp_min: 18, temp_max: 22, icon: 'sunny', main: 'Clear', description: 'clear sky',
                         wind: 5, wind_direction: 100 }
    new_reading_mock = Reading.new(new_reading_data)
    @weather_client.expects(:current_weather).with(zip: @zipcode, units: 'metric').returns(new_reading_data)
    Reading.expects(:create_from_weather_data).with(new_reading_data, zipcode: @zipcode).returns(new_reading_mock)

    assert_equal new_reading_mock, @weather.current
  end
end
