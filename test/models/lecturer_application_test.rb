# frozen_string_literal: true

require 'test_helper'

class LecturerApplicationTest < ActiveSupport::TestCase
  setup do
    @pending_application = create(:lecturer_application)
    @approved_application = create(:lecturer_application, approval_status: :approved)
    @rejected_application = create(:lecturer_application, approval_status: :rejected)
  end

  test 'cannot change approval status upon approved' do
    @approved_application.approval_status = :pending
    refute @approved_application.save
    refute_empty @approved_application.errors
  end

  test 'cannot change approval status upon rejected' do
    @rejected_application.approval_status = :pending
    refute @rejected_application.save
    refute_empty @rejected_application.errors
  end

  test 'approval of application promotes user to lecturer' do
    @pending_application.approval_status = :approved
    @pending_application.save

    @pending_application.reload
    assert_equal :lecturer, @pending_application.user.user_type.to_sym
  end

  test 'extremely large file is rejected for resume' do
    @pending_application.resume = 'a' * 1_000_000_000

    refute @pending_application.save
    refute_empty @pending_application.errors
  end
end
