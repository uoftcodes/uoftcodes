# frozen_string_literal: true

require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @approved_lecture = events(:approved_lecture)
    @non_approved_lecture = events(:non_approved_lecture)
    @non_approved_lecture2 = events(:non_approved_lecture_lecturer2)
    @admin_lecture = events(:admin_lecture)
    @past_lecture = events(:past_lecture)
  end

  test '#index returns ok with member signed in' do
    sign_in users(:member)

    get events_url
    assert_response :success
  end

  test '#index does not need sign in' do
    get events_url
    assert_response :success
  end

  test '#new returns ok with lecturer signed in' do
    sign_in users(:lecturer)

    get new_event_url
    assert_response :success
  end

  test '#new redirects with member signed in' do
    sign_in users(:member)

    get new_event_url
    assert_redirected_to events_url
  end

  test '#create creates new event for lecturer' do
    sign_in users(:lecturer)

    assert_difference('Event.count') do
      post events_url, params: { event: build_event_params }
    end

    event = Event.last

    assert_redirected_to events_url
    refute event.approved?
  end

  test '#create creates new event for admin' do
    sign_in users(:admin)

    assert_difference('Event.count') do
      post events_url, params: { event: build_event_params }
    end

    event = Event.last

    assert_redirected_to events_url
    refute event.approved?
  end

  test '#create is unauthorized for member' do
    sign_in users(:member)

    assert_no_difference('Event.count') do
      post events_url, params: { event: build_event_params }
    end

    assert_redirected_to events_url
  end

  test '#edit loads event for an ID' do
    sign_in users(:admin)

    get edit_event_url(@approved_lecture)

    assert_response :success
  end

  test '#edit lecturer cannot edit another user event' do
    sign_in users(:lecturer)

    assert_raises ActionController::RoutingError do
      get edit_event_url(@admin_lecture)
    end
  end

  test '#edit member cannot edit event' do
    sign_in users(:member)

    get edit_event_url(@admin_lecture)

    assert_redirected_to events_url
  end

  test '#update updates event for an ID' do
    sign_in users(:admin)

    patch event_url(@approved_lecture), params: { event: build_event_params(title: 'Testing 123') }

    @approved_lecture.reload

    assert_redirected_to events_url
    assert_equal 'Testing 123', @approved_lecture.title
  end

  test '#update lecturer cannot edit another user event' do
    sign_in users(:lecturer)

    assert_raises ActionController::RoutingError do
      patch event_url(@admin_lecture), params: { event: build_event_params(title: 'Testing 123') }
    end
  end

  test '#update member cannot edit event' do
    sign_in users(:member)

    patch event_url(@approved_lecture), params: { event: build_event_params(title: 'Testing 123') }

    assert_redirected_to events_url
  end

  test '#index includes only approved events for members' do
    sign_in users(:member)

    get events_path

    assert_includes assigns(:events), @approved_lecture
    assert_includes assigns(:events), @admin_lecture
    refute_includes assigns(:events), @non_approved_lecture
    refute_includes assigns(:events), @past_lecture
  end

  test '#index includes only approved events and their own lectures for lecturers' do
    sign_in users(:lecturer)

    get events_path

    assert_includes assigns(:events), @approved_lecture
    assert_includes assigns(:events), @admin_lecture
    assert_includes assigns(:events), @non_approved_lecture
    refute_includes assigns(:events), @non_approved_lecture2
    refute_includes assigns(:events), @past_lecture
  end

  test '#index includes all events for admins' do
    sign_in users(:admin)

    get events_path

    assert_includes assigns(:events), @approved_lecture
    assert_includes assigns(:events), @admin_lecture
    assert_includes assigns(:events), @non_approved_lecture
    assert_includes assigns(:events), @non_approved_lecture2
    refute_includes assigns(:events), @past_lecture
  end

  test '#show with approved event' do
    sign_in users(:member)

    get event_url(@approved_lecture)

    assert_response :success
    assert_equal @approved_lecture, assigns(:event)
  end

  test '#show with unapproved event can be viewed by creator' do
    sign_in users(:lecturer)

    get event_url(@non_approved_lecture)

    assert_response :success
    assert_equal @non_approved_lecture, assigns(:event)
  end

  test '#show with unapproved event cannot be viewed by other lecturers' do
    sign_in users(:lecturer2)

    assert_raises ActionController::RoutingError do
      get event_url(@non_approved_lecture)
    end
  end

  test '#show with unapproved event cannot be viewed by member' do
    sign_in users(:member)

    assert_raises ActionController::RoutingError do
      get event_url(@non_approved_lecture)
    end
  end

  test '#show with unapproved event can be viewed by admin' do
    sign_in users(:admin)

    get event_url(@non_approved_lecture)

    assert_response :success
    assert_equal @non_approved_lecture, assigns(:event)
  end

  test '#approve cannot be accessed by member' do
    sign_in users(:member)

    post event_approve_path(@non_approved_lecture)

    @non_approved_lecture.reload

    refute @non_approved_lecture.approved?
    assert_redirected_to events_url
  end

  test '#approve cannot be accessed by lecturer' do
    sign_in users(:lecturer)

    post event_approve_path(@non_approved_lecture)

    @non_approved_lecture.reload

    refute @non_approved_lecture.approved?
    assert_redirected_to events_url
  end

  test '#approve can be accessed by admin' do
    sign_in users(:admin)

    post event_approve_path(@non_approved_lecture)

    @non_approved_lecture.reload

    assert @non_approved_lecture.approved?
    assert_redirected_to events_url
  end

  private

  def build_event_params(**options)
    {
      title: 'Hello world!',
      location: 'BA1111',
      description: 'Lorem ipsum dolor sit amet.',
      start_time: Time.zone.now + 1.hours,
      end_time: Time.zone.now + 5.hours
    }.deep_merge(options)
  end
end
