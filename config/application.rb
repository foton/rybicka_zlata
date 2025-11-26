# frozen_string_literal: true

require File.expand_path('boot', __dir__)

require 'rails'

# to not load active_storage/engine
%w[
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  action_mailbox/engine
  action_text/engine
  rails/test_unit/railtie
].each do |railtie|
  begin # rubocop:disable Style/RedundantBegin
    require railtie
  rescue LoadError
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RybickaZlata4
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.app_domain = 'www.rybickazlata.cz'
    # config.action_mailer.default_url_options = { host: 'www.rybickazlata.cz' }

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Prague' # means THIS application running at server is in this Timezone

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}').to_s]
    config.i18n.default_locale = :cs

    # On config/application.rb forcing your application to not access the DB or load models when precompiling your assets.
    config.assets.initialize_on_precompile = false
    # config.assets.paths << Rails.root.join("app","assets","javascripts","mdl_extensions")

    def self.available_locales
      [%w[English en], %w[Čeština cs]]
    end

    def self.inform_admin(message, subject)
      # TODO: not implemented yet
    end
  end
end
