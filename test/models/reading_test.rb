# frozen_string_literal: true

require 'test_helper'

class ReadingTest < ActiveSupport::TestCase
  def setup
    @data = {
      'weather' => [{ 'icon_uri' => 'http://example.com/icon.png', 'main' => 'Cloudy',
                      'description' => 'overcast clouds' }],
      'main' => { 'temp' => 15.5, 'temp_min' => 14.0, 'temp_max' => 17.0 },
      'wind' => { 'speed' => 5.2, 'deg' => 80 }
    }
    @zipcode = '12345'
  end

  test 'validations' do
    reading = Reading.new
    assert_not reading.valid?
    assert_not_nil reading.errors[:zipcode]
    assert_not_nil reading.errors[:temp]
  end

  test 'find_recent_by_zipcode' do
    Reading.create!(zipcode: @zipcode, temp: 14, temp_min: 12, temp_max: 15, icon: 'icon1',
                    main: 'Clear', description: 'clear sky', wind: 3, wind_direction: 200, created_at: 2.days.ago)
    recent_reading = Reading.create!(zipcode: @zipcode, temp: 16, temp_min: 14, temp_max: 18, icon: 'icon2',
                                     main: 'Rainy', description: 'light rain', wind: 4, wind_direction: 100)
    assert_equal recent_reading, Reading.find_recent_by_zipcode(@zipcode)
  end

  test 'create_from_weather_data' do
    reading = Reading.create_from_weather_data(@data, zipcode: @zipcode)
    assert reading.persisted?
    assert_equal 15.5, reading.temp
  end

  test 'created_within?' do
    reading = Reading.create!(zipcode: @zipcode, temp: 14, temp_min: 12, temp_max: 15, icon: 'icon1', main: 'Clear',
                              description: 'clear sky', wind: 3, wind_direction: 200, created_at: 10.minutes.ago)
    assert reading.created_within?(15.minutes)
    assert_not reading.created_within?(5.minutes)
  end
end
