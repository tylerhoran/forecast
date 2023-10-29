# frozen_string_literal: true

require 'application_system_test_case'

class WeatherTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit weather_index_url

    assert_selector 'h2', text: 'Current US Weather'
    assert_selector 'form'
  end

  test 'submitting valid address displays weather' do
    visit weather_index_url

    fill_in 'address', with: '1600 Pennsylvania Ave NW, Washington, DC 20500'
    click_on 'Fetch Weather'

    assert_text '20500'
  end

  test 'submitting invalid address shows error' do
    visit weather_index_url

    fill_in 'address', with: 'invalid address'
    click_on 'Fetch Weather'

    assert_text 'Invalid Address'
  end
end
