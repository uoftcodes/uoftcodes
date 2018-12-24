# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[index archived_index show]
  before_action :authorize_only_like_lecturer!, only: %i[new create update edit destroy]
  before_action :authorize_only_admin!, only: %i[approve]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      flash[:info] = 'Event successfully created.'
      redirect_to events_path
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
      redirect_to events_path
    else
      flash.now[:alert] = @event.build_error_message

      render :edit
    end
  end

  def index
    @events = if current_user&.admin?
                Event.where('end_time >= ?', Time.now)
              elsif current_user&.lecturer?
                Event.where(
                  '(end_time >= ? AND approved=true) OR (end_time >= ? AND user_id=?)',
                  Time.now,
                  Time.now,
                  current_user.id
                )
              else
                Event.where('end_time >= ? AND approved=true', Time.now)
              end

    build_js_events
  end

  def archived_index
    @events = if current_user&.admin?
                Event.where('end_time < ?', Time.now)
              elsif current_user&.lecturer?
                Event.where(
                  '(end_time < ? AND approved=true) OR (end_time < ? AND user_id=?)',
                  Time.now,
                  Time.now,
                  current_user.id
                )
              else
                Event.where('end_time < ? AND approved=true', Time.now)
              end.order(start_time: :desc)
  end

  def show
    @event = Event.find_by_id(params[:id])

    raise ActionController::RoutingError, 'Not Found' if @event.nil?

    unless @event.approved? || current_user&.admin? || current_user == @event.user
      raise ActionController::RoutingError, 'Not Found'
    end

    render json: build_event_json(@event)
  end

  def approve
    @event = Event.find_by_id(params[:event_id])
    @event.approved = !@event.approved?

    @errors = @event.build_error_message unless @event.save

    render json: { approved: @event.approved, errors: @errors }
  end

  def register
    @event = Event.find_by_id(params[:event_id])
    @event_registration = EventRegistration.find_by(event: @event, user: current_user)

    if @event_registration.nil? # Create new event registration
      registered = true

      @event_registration = EventRegistration.new(event: @event, user: current_user)

      @errors = @event_registration.build_error_message unless @event_registration.save
    else # Remove existing event registration
      registered = false

      @event_registration.destroy!
    end

    render json: { registered: registered, errors: @errors }
  end

  private

  def build_js_events
    gon.events = @events.to_a.map do |e|
      {
        id: e.id,
        title: e.title,
        start: e.start_time,
        end: e.end_time
      }
    end
  end

  def build_event_json(event)
    {
      event_id: event.id,
      title: event.title,
      location: event.location,
      description: event.description,
      start_time: event.start_time,
      end_time: event.end_time,
      approved: event.approved,
      registered: current_user.nil? ? nil : !EventRegistration.find_by(user: current_user, event: event).nil?
    }
  end

  def find_event_by_id!
    @event = Event.find_by_id(params[:id])

    unless current_user.admin?
      @event = nil if @event.user.id != current_user.id
    end

    raise ActionController::RoutingError, 'Not Found' if @event.nil?
  end

  def event_params
    params.require(:event).permit(:title, :location, :description, :start_time, :end_time)
  end
end
