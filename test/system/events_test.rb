# frozen_string_literal: true

require 'application_system_test_case'

class EventsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @event = create(:event,
                    title: Faker::Lorem.sentence,
                    description: Faker::Lorem.paragraph,
                    approved: true)

    Capybara.current_driver = Capybara.javascript_driver
  end

  test 'viewing events when not signed in' do
    visit events_path

    find('*', text: /\A#{@event.title}\z/).click

    assert_text(:visible, @event.title)
    assert_text(:visible, @event.description)
  end

  test 'viewing events when signed in as member' do
    sign_in create(:user, user_type: :member)

    visit events_path

    find('*', text: /\A#{@event.title}\z/).click

    assert_text(:visible, @event.title)
    assert_text(:visible, @event.description)

    register_button = page.all('#register_event_button')[0]
    assert register_button.visible?
    assert_equal 'Register', register_button.text
  end

  test 'registering and unregistering to event when signed in as member' do
    sign_in create(:user, user_type: :member)

    visit events_path

    find('*', text: /\A#{@event.title}\z/).click

    register_button = page.all('#register_event_button')[0]
    assert_equal 'Register', register_button.text

    register_button.click
    wait_for_ajax
    assert_equal 'Unregister', register_button.text

    register_button.click
    wait_for_ajax
    assert_equal 'Register', register_button.text
  end

  test 'approving and unapproving event when signed in as admin' do
    sign_in create(:user, user_type: :admin)

    visit events_path

    find('*', text: /\A#{@event.title}\z/).click
    approve_button = page.all('#approve_event_button')[0]
    assert_equal 'Unapprove', approve_button.text

    page.accept_alert do
      approve_button.click
    end
    wait_for_ajax
    assert_equal 'Approve', approve_button.text

    page.accept_alert do
      approve_button.click
    end
    wait_for_ajax
    assert_equal 'Unapprove', approve_button.text
  end
end
