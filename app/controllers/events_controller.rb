# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :authorize_only_lecturer, only: %i[new create update edit destroy]
  before_action :authorize_only_admin, only: %i[approve]
  before_action :authenticate_user!, except: %i[index show]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      flash[:info] = 'Event successfully created.'
      redirect_to events_url
    else
      flash.now[:alert] = @event.build_error_message

      render :new
    end
  end

  def edit
    find_event_by_id!
  end

  def update
    find_event_by_id!

    if @event.update(event_params)
      flash[:info] = 'Event successfully created.'
      redirect_to events_url
    else
      flash.now[:alert] = @event.build_error_message

      render :edit
    end
  end

  def index
    @events = if current_user.nil?
                Event.where('end_time >= ? AND approved=true', Time.now)
              elsif current_user.admin?
                Event.where('end_time >= ?', Time.now)
              elsif current_user.lecturer?
                Event.where(
                  '(end_time >= ? AND approved=true) OR (end_time >= ? AND user_id=?)',
                  Time.now,
                  Time.now,
                  current_user.id
                )
              else
                Event.where('end_time >= ? AND approved=true', Time.now)
              end
  end

  def show
    @event = Event.find_by_id(params[:id])

    raise ActionController::RoutingError, 'Not Found' if @event.nil?

    unless @event.approved? || current_user.admin? || current_user == @event.user
      raise ActionController::RoutingError, 'Not Found'
    end

    render json: @event
  end

  def approve
    @event = Event.find_by_id(params[:event_id])
    @event.approved = !@event.approved?

    if @event.save
      flash[:info] = if @event.approved
                       'Event has been approved: ' + @event.title
                     else
                       'Event has been unapproved: ' + @event.title
                     end
    else
      flash[:alert] = @event.build_error_message
    end

    redirect_to events_url
  end

  private

  def find_event_by_id!
    @event = Event.find_by_id(params[:id])

    unless current_user.admin?
      @event = nil if @event.user.id != current_user.id
    end

    raise ActionController::RoutingError, 'Not Found' if @event.nil?
  end

  def unauthorized_redirect
    flash[:alert] = 'You are unauthorized to visit that page.'
    redirect_to events_url
  end

  def authorize_only_lecturer
    unauthorized_redirect unless current_user.like_lecturer?
  end

  def authorize_only_admin
    unauthorized_redirect unless current_user.admin?
  end

  def event_params
    params.require(:event).permit(:title, :location, :description, :start_time, :end_time)
  end
end
