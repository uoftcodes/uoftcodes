# frozen_string_literal: true

require 'test_helper'

class HomepageControllerTest < ActionDispatch::IntegrationTest
  test 'home page returns a ok response' do
    get root_path
    assert_response :ok
  end
end
