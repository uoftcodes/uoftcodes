# frozen_string_literal: true

class HomepageController < ApplicationController
  skip_before_action :authenticate_user!

  def homepage
    @events = Event.where('end_time >= ? AND approved=true', Time.now).order('start_time ASC')
  end
end
