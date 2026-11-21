# frozen_string_literal: true

# Propshaft: every file in app/assets (and gems' asset paths) is served with a digest.
# Stylesheets are linked by `stylesheet_link_tag :app` (all of app/assets/stylesheets),
# JavaScript goes through importmap (config/importmap.rb).

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
