# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_181_126_152_912) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'event_registrations', force: :cascade do |t|
    t.bigint 'events_id'
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['events_id'], name: 'index_event_registrations_on_events_id'
    t.index ['user_id'], name: 'index_event_registrations_on_user_id'
  end

  create_table 'events', force: :cascade do |t|
    t.bigint 'user_id'
    t.string 'title', null: false
    t.string 'location', null: false
    t.binary 'banner'
    t.text 'description', null: false
    t.datetime 'start_time', null: false
    t.datetime 'end_time', null: false
    t.boolean 'approved', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_events_on_user_id'
  end

  create_table 'lecturer_applications', force: :cascade do |t|
    t.bigint 'user_id'
    t.binary 'resume', null: false
    t.text 'interests', null: false
    t.text 'additional_info'
    t.boolean 'student', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'approval_status', default: 0, null: false
    t.index ['user_id'], name: 'index_lecturer_applications_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.inet 'current_sign_in_ip'
    t.inet 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.integer 'failed_attempts', default: 0, null: false
    t.string 'unlock_token'
    t.datetime 'locked_at'
    t.integer 'user_type', default: 0, null: false
    t.string 'first_name', null: false
    t.string 'last_name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'student_number'
    t.index ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['unlock_token'], name: 'index_users_on_unlock_token', unique: true
  end
end
