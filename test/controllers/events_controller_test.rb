# frozen_string_literal: true

require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @member = create(:user, user_type: :member)
    @lecturer = create(:user, user_type: :lecturer)
    @admin = create(:user, user_type: :admin)

    @approved_lecture = create(:event)
    @non_approved_lecture = create(:event, approved: false, user: @lecturer)
    @past_lecture = create(:event, start_time: 2.hours.ago, end_time: 1.hour.ago)
    @non_approved_past_lecture = create(:event, start_time: 2.hours.ago, end_time: 1.hour.ago,
                                                approved: false, user: @lecturer)
  end

  test '#index returns ok with member signed in' do
    sign_in @member

    get events_path
    assert_response :success
  end

  test '#index does not need sign in' do
    get events_path
    assert_response :success
  end

  test '#new returns ok with lecturer signed in' do
    sign_in @lecturer

    get new_event_path
    assert_response :success
  end

  test '#new redirects with member signed in' do
    sign_in @member

    get new_event_path
    assert_redirected_to events_path
  end

  test '#create creates new event for lecturer' do
    sign_in @lecturer

    assert_difference('Event.count') do
      post events_path, params: { event: build_event_params }
    end

    event = Event.last

    assert_redirected_to events_path
    refute event.approved?
  end

  test '#create creates new event for admin' do
    sign_in @admin

    assert_difference('Event.count') do
      post events_path, params: { event: build_event_params }
    end

    event = Event.last

    assert_redirected_to events_path
    refute event.approved?
  end

  test '#create is unauthorized for member' do
    sign_in @member

    assert_no_difference('Event.count') do
      post events_path, params: { event: build_event_params }
    end

    assert_redirected_to events_path
  end

  test '#edit loads event for an ID' do
    sign_in @admin

    get edit_event_path(@approved_lecture)

    assert_response :success
  end

  test '#edit lecturer cannot edit another user event' do
    sign_in @lecturer

    assert_raises ActionController::RoutingError do
      get edit_event_path(@approved_lecture)
    end
  end

  test '#edit member cannot edit event' do
    sign_in @member

    get edit_event_path(@approved_lecture)

    assert_redirected_to events_path
  end

  test '#update updates event for an ID' do
    sign_in @admin

    patch event_path(@approved_lecture), params: { event: build_event_params(title: 'Testing 123') }

    @approved_lecture.reload

    assert_redirected_to events_path
    assert_equal 'Testing 123', @approved_lecture.title
  end

  test '#update lecturer cannot edit another user event' do
    sign_in @lecturer

    assert_raises ActionController::RoutingError do
      patch event_path(@approved_lecture), params: { event: build_event_params(title: 'Testing 123') }
    end
  end

  test '#update member cannot edit event' do
    sign_in @member

    patch event_path(@approved_lecture), params: { event: build_event_params(title: 'Testing 123') }

    assert_redirected_to events_path
  end

  test '#index includes only approved events for members' do
    sign_in @member

    get events_path

    assert_includes assigns(:events), @approved_lecture
    refute_includes assigns(:events), @non_approved_lecture
    refute_includes assigns(:events), @past_lecture
  end

  test '#index includes only approved events and their own lectures for lecturers' do
    sign_in @lecturer

    lecturer2 = create(:user, user_type: :lecturer)
    non_approved_lecture2 = create(:event, approved: false, user: lecturer2)

    get events_path

    assert_includes assigns(:events), @approved_lecture
    assert_includes assigns(:events), @non_approved_lecture
    refute_includes assigns(:events), non_approved_lecture2
    refute_includes assigns(:events), @past_lecture
  end

  test '#index includes all events for admins' do
    sign_in @admin

    get events_path

    assert_includes assigns(:events), @approved_lecture
    assert_includes assigns(:events), @non_approved_lecture
    refute_includes assigns(:events), @past_lecture
  end

  test '#archived_index includes approved past events for non signed in' do
    sign_in @member

    get events_archived_path

    assert_response :success
    assert_includes assigns(:events), @past_lecture
    refute_includes assigns(:events), @non_approved_past_lecture
    refute_includes assigns(:events), @approved_lecture
  end

  test '#archived_index includes approved past events for members' do
    sign_in @member

    get events_archived_path

    assert_response :success
    assert_includes assigns(:events), @past_lecture
    refute_includes assigns(:events), @non_approved_past_lecture
    refute_includes assigns(:events), @approved_lecture
  end

  test '#archived_index includes approved past events and their own events for lecturers' do
    sign_in @lecturer

    get events_archived_path

    assert_response :success
    assert_includes assigns(:events), @past_lecture
    assert_includes assigns(:events), @non_approved_past_lecture
    refute_includes assigns(:events), @approved_lecture
  end

  test '#archived_index includes all past events for admins' do
    sign_in @admin

    get events_archived_path

    assert_response :success
    assert_includes assigns(:events), @past_lecture
    assert_includes assigns(:events), @non_approved_past_lecture
    refute_includes assigns(:events), @approved_lecture
  end

  test '#show with approved event' do
    sign_in @member

    get event_path(@approved_lecture)

    assert_response :success
    assert_equal @approved_lecture, assigns(:event)
  end

  test '#show with unapproved event can be viewed by creator' do
    sign_in @lecturer

    get event_path(@non_approved_lecture)

    assert_response :success
    assert_equal @non_approved_lecture, assigns(:event)
  end

  test '#show with unapproved event cannot be viewed by other lecturers' do
    sign_in create(:user, user_type: :lecturer)

    assert_raises ActionController::RoutingError do
      get event_path(@non_approved_lecture)
    end
  end

  test '#show with unapproved event cannot be viewed by member' do
    sign_in @member

    assert_raises ActionController::RoutingError do
      get event_path(@non_approved_lecture)
    end
  end

  test '#show with unapproved event can be viewed by admin' do
    sign_in @admin

    get event_path(@non_approved_lecture)

    assert_response :success
    assert_equal @non_approved_lecture, assigns(:event)
  end

  test '#approve cannot be accessed by member' do
    sign_in @member

    post event_approve_path(@non_approved_lecture)

    @non_approved_lecture.reload

    refute @non_approved_lecture.approved?
    assert_redirected_to events_path
  end

  test '#approve cannot be accessed by lecturer' do
    sign_in @lecturer

    post event_approve_path(@non_approved_lecture)

    @non_approved_lecture.reload

    refute @non_approved_lecture.approved?
    assert_redirected_to events_path
  end

  test '#approve can be accessed by admin' do
    sign_in @admin

    assert_emails User.count + 1 do
      perform_enqueued_jobs do
        post event_approve_path(@non_approved_lecture)
      end
    end

    @non_approved_lecture.reload

    response = JSON.parse(@response.body)

    assert @non_approved_lecture.approved?
    assert response['approved']
    assert_nil response['errors']

    email_deliveries = ActionMailer::Base.deliveries
    assert_equal 6, email_deliveries.length
    assert(email_deliveries.any? { |email| email.to.include? @non_approved_lecture.user.email })
    assert(email_deliveries.any? { |email| email.to.include? @member.email })
  end

  test '#register cannot be access when not logged in' do
    assert_no_difference('EventRegistration.count') do
      assert_no_emails do
        perform_enqueued_jobs do
          post event_register_path(@approved_lecture)
        end
      end
    end
  end

  test '#register cannot register for unapproved event' do
    sign_in @admin

    assert_no_difference('EventRegistration.count') do
      assert_no_emails do
        perform_enqueued_jobs do
          post event_register_path(@non_approved_lecture)
        end
      end
    end

    response = JSON.parse(@response.body)
    refute_nil response['errors']
  end

  test '#register registers on first call' do
    sign_in @member

    assert_difference('EventRegistration.count') do
      assert_emails 1 do
        perform_enqueued_jobs do
          post event_register_path(@approved_lecture)
        end
      end
    end

    response = JSON.parse(@response.body)
    assert response['registered']
    assert_nil response['errors']
  end

  test '#register unregisters when registered' do
    user = create(:user)
    sign_in user
    create(:event_registration, user: user)

    assert_difference('EventRegistration.count') do
      assert_emails 1 do
        perform_enqueued_jobs do
          post event_register_path(@approved_lecture)
        end
      end
    end

    response = JSON.parse(@response.body)
    assert response['registered']
    assert_nil response['errors']
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
