# frozen_string_literal: true

class Reading < ApplicationRecord
  validates_presence_of :zipcode, :temp, :temp_min, :temp_max, :icon, :main, :description, :wind, :wind_direction
  attr_accessor :cached

  def self.find_recent_by_zipcode(zipcode)
    order(created_at: :desc).find_by(zipcode:)
  end

  def created_within?(time_frame)
    created_at > Time.now - time_frame
  end

  def self.create_from_weather_data(data, zipcode:)
    weather = data['weather'].first
    create!(
      zipcode:,
      temp: data.dig('main', 'temp'),
      temp_min: data.dig('main', 'temp_min'),
      temp_max: data.dig('main', 'temp_max'),
      icon: weather['icon_uri'].to_s,
      main: weather['main'],
      description: weather['description'],
      wind: data.dig('wind', 'speed'),
      wind_direction: data.dig('wind', 'deg')
    )
  end
end
