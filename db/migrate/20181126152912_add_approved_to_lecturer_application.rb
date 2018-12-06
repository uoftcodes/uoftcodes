# frozen_string_literal: true

class AddApprovedToLecturerApplication < ActiveRecord::Migration[5.2]
  def change
    add_column :lecturer_applications, :approval_status, :integer, default: 0, null: false
  end
end
