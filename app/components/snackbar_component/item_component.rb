# frozen_string_literal: true

class SnackbarComponent
  # One snackbar (SnackbarComponent::Message).
  class ItemComponent < ApplicationComponent
    def initialize(message:)
      super()
      @message = message
    end

    attr_reader :message
  end
end
