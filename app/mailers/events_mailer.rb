# frozen_string_literal: true

class EventsMailer < ApplicationMailer
  default from: 'noreply@uoftcodes.com'

  def register_email(event_registration)
    @user = event_registration.user
    @event = event_registration.event

    mail(to: @user.email, subject: 'Registered to event ' + @event.title)
  end

  def unregister_email(user, event)
    @user = user
    @event = event

    mail(to: @user.email, subject: 'Unregistered from event ' + @event.title)
  end

  def approve_email(event)
    @user = event.user
    @event = event

    mail(to: @user.email, subject: 'Your event has been approved')
  end

  def reminder_email(event_registration)
    @user = event_registration.user
    @event = event_registration.event

    mail(to: @user.email, subject: 'Upcoming event ' + @event.title)
  end

  def creation_email(event, user)
    @user = user
    @event = event

    mail(to: @user.email, subject: 'New event ' + @event.title)
  end
end
