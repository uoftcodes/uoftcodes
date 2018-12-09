# frozen_string_literal: true

require 'test_helper'

class LecturerApplicationControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @unapproved_lecturer_application_user = create(:user)
    @unapproved_lecturer_application = create(:lecturer_application, user: @unapproved_lecturer_application_user)

    @approved_lecturer_application_user = create(:user, user_type: :lecturer)
    @approved_lecturer_application = create(:lecturer_application, user: @approved_lecturer_application_user)
  end

  test '#new is not accessible for lecturer' do
    sign_in create(:user, user_type: :lecturer)

    get new_lecturer_application_path
    assert_redirected_to root_path
  end

  test '#new is accessible for member' do
    sign_in create(:user)

    get new_lecturer_application_path
    assert_response :success
  end

  test '#create is not accessible for lecturer' do
    sign_in create(:user, user_type: :lecturer)

    assert_no_difference('LecturerApplication.count') do
      post lecturer_applications_path,
           params: { lecturer_application: build_lecturer_application_params }
    end

    assert_redirected_to root_path
  end

  test '#create is accessible for member' do
    sign_in create(:user)

    assert_difference('LecturerApplication.count') do
      post lecturer_applications_path,
           params: { lecturer_application: build_lecturer_application_params }
    end

    assert_redirected_to lecturer_application_path(LecturerApplication.last)
  end

  test '#create validates resume is a pdf' do
    sign_in create(:user)

    assert_no_difference('LecturerApplication.count') do
      post lecturer_applications_path,
           params: { lecturer_application: build_lecturer_application_params(
             resume: fixture_file_upload('files/resume.pdf', '')
           ) }
    end

    assert_template :new
  end

  test '#show is not accessible for another user application' do
    sign_in create(:user, user_type: :lecturer)

    assert_raise ActionController::RoutingError do
      get lecturer_application_path(@unapproved_lecturer_application)
    end
  end

  test '#show is accessible for own application' do
    sign_in @unapproved_lecturer_application_user

    get lecturer_application_path(@unapproved_lecturer_application)
    assert_response :success
    assert_equal @unapproved_lecturer_application, assigns(:lecturer_application)
  end

  test '#show is accessible for admin on any user' do
    sign_in create(:user, user_type: :admin)

    get lecturer_application_path(@unapproved_lecturer_application)
    assert_response :success
    assert_equal @unapproved_lecturer_application, assigns(:lecturer_application)
  end

  private

  def build_lecturer_application_params(**options)
    {
      resume: fixture_file_upload('files/resume.pdf', 'application/pdf'),
      interests: Faker::Lorem.paragraph,
      additional_info: Faker::Lorem.paragraph
    }.deep_merge(options)
  end
end
