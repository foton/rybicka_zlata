# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

# Entry point is "rz" (not "application"), because Sprockets already serves
# legacy app/assets/javascripts/application.js under the same logical path.
pin 'rz'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin_all_from 'app/javascript/elements', under: 'elements'
