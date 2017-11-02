# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg'
gem 'rails'

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

gem 'sendgrid' # for sending emails in production

group :development, :test do
  # Coffee-rails and Uglifier demands ExecJS, which require JS runtime.
  # So I pick up Rubyracer
  # Production is on Heroku where they have NODE, so no rubyracer is needed there https://devcenter.heroku.com/articles/rails-asset-pipeline
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby

  gem 'pry-byebug' # debugging with pry on ruby 2 ('step','next','finish','continue')
  gem 'pry-rails' # pry misto IRB v rails console

  gem 'minitest-reporters' # better formatted output of Minitest

  # managing secrets
  gem 'dotenv-heroku' # upload secrets to HEROKU as ENV variables
  gem 'dotenv-rails' # loads secrets from .env file into ENV variables
end

group :development do
  # speeds up development by keeping your application running in the background.
  gem 'spring'

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

  gem 'simplecov'

  # TODO:  refactor tests to delete this
  gem 'rails-controller-testing' # for assert_template  and assigns
end
