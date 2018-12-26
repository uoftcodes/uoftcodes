# frozen_string_literal: true

require 'test_helper'

class HomepageControllerTest < ActionDispatch::IntegrationTest
  setup do
    @approved_lecture = create(:event, approved: true)
    @non_approved_lecture = create(:event, approved: false)
    @past_lecture = create(:event, start_time: 2.hours.ago, end_time: 1.hour.ago)
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
