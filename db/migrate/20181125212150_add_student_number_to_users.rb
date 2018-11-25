# frozen_string_literal: true

class AddStudentNumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :student_number, :string
  end
end
