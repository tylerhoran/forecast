# frozen_string_literal: true

class WeatherController < ApplicationController
  def index
    return unless params[:address]

    begin
      weather_service = Weather.new(params[:address])
      @weather = weather_service.current
    rescue StandardError => e
      # Capture any errors and make them available to the view
      @error = e.message
    end
  end
end
