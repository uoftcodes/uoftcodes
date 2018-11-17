# frozen_string_literal: true

require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest
  test 'can access signup page' do
    get new_user_registration_path

    assert_response :success
  end

  test 'empty first name causes error' do
    assert_no_difference 'User.count' do
      post user_registration_path, params: { user: build_user_params(first_name: '') }
    end

    refute_empty flash
  end

  test 'successful sign up redirects to login' do
    assert_emails 1 do
      assert_difference 'User.count' do
        post user_registration_path, params: { user: build_user_params }
      end
    end

    assert_redirected_to new_user_session_path
  end

  private

  def build_user_params(**options)
    {
      first_name: 'Bob',
      last_name: 'Builder',
      email: 'bob@gmail.com',
      password: 'password',
      password_confirmation: 'password'
    }.deep_merge(options)
  end
end
