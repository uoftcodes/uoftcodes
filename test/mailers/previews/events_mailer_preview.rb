# frozen_string_literal: true

require 'factory_bot'
require 'faker'

# Preview all emails at http://localhost:3000/rails/mailers/events_mailer
class EventsMailerPreview < ActionMailer::Preview
  def register_email
    EventsMailer.register_email(FactoryBot.build_stubbed(:event_registration))
  end

  def unregister_email
    EventsMailer.unregister_email(FactoryBot.build_stubbed(:user), FactoryBot.build_stubbed(:event))
  end

  def approve_email
    EventsMailer.approve_email(FactoryBot.build_stubbed(:event))
  end

  def reminder_email
    EventsMailer.reminder_email(FactoryBot.build_stubbed(:event_registration))
  end

  def creation_email
    EventsMailer.creation_email(FactoryBot.build_stubbed(:event), FactoryBot.build_stubbed(:user))
  end
end
