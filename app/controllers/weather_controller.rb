# frozen_string_literal: true

class WeatherController < ApplicationController
  def index
    return unless params[:address]

    begin
      weather_service = Weather.new(params[:address])
      @weather = weather_service.current
    rescue StandardError => e
      @error = e.message
    end
  end
end
