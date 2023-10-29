# frozen_string_literal: true

class Weather
  def initialize(address)
    @address = address
    @weather_client = default_weather_client
    @zipcode = nil
  end

  def current
    geocode_address
    if cached_reading_valid?
      cached_reading.cached = true
      return cached_reading
    end
    fetch_and_cache_new_reading
  end

  private

  def geocode_address
    @zipcode ||= AddressGeocoder.geocode(@address)
  end

  def cached_reading
    @cached_reading ||= Reading.find_recent_by_zipcode(@zipcode)
  end

  def cached_reading_valid?
    cached_reading&.created_within?(30.minutes)
  end

  def fetch_and_cache_new_reading
    reading = @weather_client.current_weather(zip: @zipcode, units: 'metric')
    Reading.create_from_weather_data(reading, zipcode: @zipcode)
  rescue Faraday::ResourceNotFound
    raise 'Weather data not found for provided address'
  end

  def default_weather_client
    OpenWeather::Client.new(api_key: ENV['OPEN_WEATHER_API_KEY'])
  end
end

