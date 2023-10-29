# frozen_string_literal: true

class AddressGeocoder
  def self.geocode(address)
    response = Geocoder.search(address)
    validate_response(response)
    extract_zipcode(response.first)
  end

  def self.validate_response(response)
    raise 'Invalid Address' if response.empty?
    raise 'Only US Addresses Supported' if response.first.data.dig('address', 'country_code') != 'us'
  end

  def self.extract_zipcode(geocode_data)
    geocode_data.data.dig('address', 'postcode')
  end
end
