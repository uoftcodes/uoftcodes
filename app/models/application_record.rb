# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def build_error_message
    'You have errors: ' + errors.full_messages.map(&:downcase).join(', ')
  end
end
