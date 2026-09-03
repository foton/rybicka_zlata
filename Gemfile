# frozen_string_literal: true

ruby '4.0.6'
source 'https://rubygems.org'

# webserver https://devcenter.heroku.com/articles/ruby-default-web-server
# gem 'puma'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg'
gem 'rails', '~> 8.1.3', '>= 8.1.3.1'

# Use Puma as the app server
gem 'puma'

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# authorization
gem 'devise'
gem 'devise-i18n'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter'

# gem 'nokogiri', '1.10.5'
gem 'activity_notification'

group :development, :test do
  # Coffee-rails and Uglifier demand ExecJS, which uses the local Node runtime.
  # Production is on Heroku where Node is available: https://devcenter.heroku.com/articles/rails-asset-pipeline
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'pry-byebug', require: false # debugging with pry ('step', 'next', 'finish', 'continue')
  gem 'pry-rails' # pry in Rails console instead IRB

  gem 'minitest-reporters' # better formatted output of Minitest

  # managing secrets
  gem 'dotenv-heroku' # upload secrets to HEROKU as ENV variables
  gem 'dotenv-rails' # loads secrets from .env file into ENV variables
end

group :development do
  # speeds up development by keeping your application running in the background.

  # style check, allways learning best practicies
  gem 'rubocop', require: false
  gem 'rubocop-rails'

  gem 'annotate' # write DB structure as comments in models etc.
  gem 'bundle-audit'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner', require: false
  gem 'minitest-mock', require: 'minitest/mock'
  gem 'selenium-webdriver', require: false

  # TODO:  refactor tests to delete this
  gem 'rails-controller-testing' # for assert_template  and assigns
end
