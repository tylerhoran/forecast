# frozen_string_literal: true

require 'test_helper'
require 'mocha/minitest'

class AddressGeocoderTest < ActiveSupport::TestCase
  def test_valid_us_address
    mock_response = mock
    mock_response.stubs(:data).returns({ 'address' => { 'postcode' => '12345', 'country_code' => 'us' } })
    Geocoder.stubs(:search).returns([mock_response])

    assert_equal '12345', AddressGeocoder.geocode('1600 Pennsylvania Ave NW, Washington, DC 20500')
  end

  def test_invalid_address
    Geocoder.stubs(:search).returns([])
    assert_raises(RuntimeError, 'Invalid Address') do
      AddressGeocoder.geocode('This is not a real address')
    end
  end

  def test_non_us_address
    mock_response = mock
    mock_response.stubs(:data).returns({ 'address' => { 'postcode' => 'ABCDE', 'country_code' => 'uk' } })
    Geocoder.stubs(:search).returns([mock_response])

    assert_raises(RuntimeError, 'Only US Addresses Supported') do
      AddressGeocoder.geocode('10 Downing St, Westminster, London SW1A 2AA, UK')
    end
  end
end
