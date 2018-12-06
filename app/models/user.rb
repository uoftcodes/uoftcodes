# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  enum user_type: { member: 0, lecturer: 1, admin: 2 }
  validates_presence_of :first_name, :last_name

  before_create :check_skip_confirmation

  def like_lecturer?
    lecturer? || admin?
  end

  def skip_confirmation
    !!@skip_confirmation
  end

  def skip_confirmation=(skip_conf)
    @skip_confirmation = (skip_conf == '1')
  end

  def check_skip_confirmation
    skip_confirmation! if @skip_confirmation
  end

  def name
    if first_name.nil? || last_name.nil?
      ''
    else
      first_name + ' ' + last_name
    end
  end
end
