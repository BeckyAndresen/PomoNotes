require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.feature 'Timer', type: :feature, js: true do
  include ActiveSupport::Testing::TimeHelpers

  before { visit root_path }

  scenario 'has a default timer of 40 minutes' do
    page.should have_selector text: '00:40:00', id: 'timer'
  end

  describe 'has a start button that' do
    scenario 'can be clicked' do
      page.should have_selector :button, text: 'Start', id: 'start-pause'
    end

    context 'when clicked' do
      before { click_button 'Start', id: 'start-pause' }

      scenario 'turns into a stop button' do
        page.should have_selector :button, text: 'Pause', id: 'start-pause'
      end

      scenario 'turns back to start button after stopping' do
        click_button 'Pause', id: 'start-pause'
        page.should have_selector :button, text: 'Start', id: 'start-pause'
      end
    end

    # Skipped until there's a way to properly test these as there's no
    # way to tell the selenium driver to move through time (`travel_to`
    # only applies to Rails)
    describe 'counts down after start button is clicked and', skip: true do
      before { click_button 'Start', id: 'start-pause' }

      scenario 'has the correct time after 1 second' do
        travel_to 1.second.from_now
        page.should have_selector text: '00:39:59', id: 'timer'
      end

      scenario 'has the correct time after 5 seconds' do
        travel_to 5.seconds.from_now
        page.should have_selector text: '00:39:55', id: 'timer'
      end
    end
  end
end
