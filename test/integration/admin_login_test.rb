# frozen_string_literal: true

require 'test_helper'

class AdminLoginTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test 'cannot access admin dashboard without authentication' do
    get rails_admin_path

    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end

  test 'user with member permissions cannot access admin dashboard' do
    sign_in users(:member)

    get rails_admin_path

    assert_response :redirect
    assert_redirected_to '/'
  end

  test 'user with lecturer permissions cannot access admin dashboard' do
    sign_in users(:lecturer)

    get rails_admin_path

    assert_response :redirect
    assert_redirected_to '/'
  end

  test 'user with admin permissions can access admin dashboard' do
    sign_in users(:admin)

    get rails_admin_path

    assert_response :ok
  end
end
