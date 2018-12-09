# frozen_string_literal: true

class ChangeResumeTypeFromBinaryToString < ActiveRecord::Migration[5.2]
  def change
    change_column :lecturer_applications, :resume, :text, null: false, limit: 10.megabytes
  end
end
