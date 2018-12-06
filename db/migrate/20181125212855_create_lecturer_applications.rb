# frozen_string_literal: true

class CreateLecturerApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :lecturer_applications do |t|
      t.references :user
      t.binary :resume, null: false
      t.text :interests, null: false
      t.text :additional_info
      t.boolean :student, null: false
      t.timestamps
    end
  end
end
