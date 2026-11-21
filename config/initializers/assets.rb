# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# No minification in any environment: Uglifier cannot parse ES modules (importmap)
# and the sass compressor (default of sassc-rails, also in dev/test) chokes on
# modern CSS. Sprockets still writes .gz variants, served by ActionDispatch::Static.
Rails.application.config.assets.js_compressor = nil
Rails.application.config.assets.css_compressor = nil
