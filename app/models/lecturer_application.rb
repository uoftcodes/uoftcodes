# frozen_string_literal: true

class LecturerApplication < ApplicationRecord
  belongs_to :user
  validates_presence_of :resume, :interests, :student
  validate :cannot_change_approval_status_upon_decision
  enum approval_status: { pending: 0, approved: 1, rejected: 2 }
  after_save :perform_approval_decision

  private

  def cannot_change_approval_status_upon_decision
    return if approval_status_was.to_sym == :pending

    errors.add(:approval_status, 'can\'t change approval status after a decision is made')
  end

  def perform_approval_decision
    user.update!(user_type: :lecturer) if approved?
  end
end
