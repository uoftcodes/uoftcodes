# frozen_string_literal: true

require 'test_helper'

class HomepageControllerTest < ActionDispatch::IntegrationTest
  setup do
    @approved_lecture = events(:approved_lecture)
    @non_approved_lecture = events(:non_approved_lecture)
    @admin_lecture = events(:admin_lecture)
    @past_lecture = events(:past_lecture)
  end

  test '#homepage returns an ok response' do
    get root_path
    assert_response :ok
  end

  test '#homepage lists upcoming events' do
    get root_path

    assert_includes assigns(:events), @approved_lecture
    refute_includes assigns(:events), @non_approved_lecture
    refute_includes assigns(:events), @past_lecture
  end
end
