# frozen_string_literal: true

ruby '2.5.3'
source 'https://rubygems.org'

# webserver https://devcenter.heroku.com/articles/ruby-default-web-server
# gem 'puma'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg'
gem 'rails', '5.2.4.3'

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

# authorization
gem 'devise'
gem 'devise-i18n'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-rails_csrf_protection'

gem 'sendgrid' # for sending emails in production
#gem 'nokogiri', '1.10.5'

group :development, :test do
  # Coffee-rails and Uglifier demands ExecJS, which require JS runtime.
  # So I pick up MiniRacer
  # Production is on Heroku where they have NODE, so no rubyracer is needed there https://devcenter.heroku.com/articles/rails-asset-pipeline
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'mini_racer', platforms: :ruby

  gem 'pry-byebug' # debugging with pry on ruby 2 ('step','next','finish','continue')
  gem 'pry-rails' # pry in Rails console instead IRB

  gem 'minitest-reporters' # better formatted output of Minitest

  # managing secrets
  gem 'dotenv-heroku' # upload secrets to HEROKU as ENV variables
  gem 'dotenv-rails' # loads secrets from .env file into ENV variables
end

group :development do
  # speeds up development by keeping your application running in the background.
  gem 'spring'
  gem 'spring-watcher-listen'

  # style check, allways learning best practicies
  gem 'rubocop', require: false
end

group :test do
  gem 'capybara-webkit', require: false
  # ^ need QT installed for Ubuntu:
  # sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base
  # sudo apt-get install gstreamer1.0-tools gstreamer1.0-x
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner', require: false

  # TODO:  refactor tests to delete this
  gem 'rails-controller-testing' # for assert_template  and assigns
end
