# frozen_string_literal: true

module DeviseHelper
  def devise_error_messages!
    return unless resource.errors.any?

    messages = 'You have errors: ' + resource.errors.full_messages.map(&:downcase).join(', ')

    flash.now[:alert] = messages
  end
end
