# frozen_string_literal: true

class ChangeStudentNullable < ActiveRecord::Migration[5.2]
  def change
    change_column :lecturer_applications, :student, :boolean, null: true
  end
end
