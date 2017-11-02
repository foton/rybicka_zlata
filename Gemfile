# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg', '0.21.0'
gem 'rails', '5.1.4'

# Use SCSS for stylesheets
gem 'sass-rails', '5.0.6'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '3.2.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '4.2.2'

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.3.1'

# authorization
gem 'devise', '4.3.0'
gem 'devise-i18n', '1.4.0'
gem 'omniauth-facebook', '4.0.0'
gem 'omniauth-github', '1.3.0'
gem 'omniauth-google-oauth2', '0.5.2'
gem 'omniauth-linkedin-oauth2', '0.2.5'
gem 'omniauth-oauth2', '1.4.0'
gem 'omniauth-twitter', '1.4.0'

gem 'sendgrid', '1.2.4' # for sending emails in production

group :development, :test do
  # Coffee-rails and Uglifier demands ExecJS, which require JS runtime.
  # So I pick up Rubyracer
  # Production is on Heroku where they have NODE, so no rubyracer is needed there https://devcenter.heroku.com/articles/rails-asset-pipeline
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'therubyracer', '0.12.3', platforms: :ruby

  gem 'pry-byebug', '3.5.0' # debugging with pry on ruby 2 ('step','next','finish','continue')
  gem 'pry-rails', '0.3.6' # pry misto IRB v rails console

  gem 'minitest-reporters', '1.1.18' # better formatted output of Minitest

  # managing secrets
  gem 'dotenv-heroku', '0.0.1' # upload secrets to HEROKU as ENV variables
  gem 'dotenv-rails', '2.2.1' # loads secrets from .env file into ENV variables
end

group :development do
  # speeds up development by keeping your application running in the background.
  gem 'spring', '2.0.2'

  # style check, allways learning best practicies
  gem 'rubocop', '0.51.0', require: false
end

group :test do
  gem 'capybara-webkit', '1.14.0', require: false
  # ^ need QT installed for Ubuntu:
  # sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base
  # sudo apt-get install gstreamer1.0-tools gstreamer1.0-x
  gem 'cucumber', '3.0.1'
  gem 'cucumber-rails', '1.5.0', require: false
  gem 'database_cleaner', '1.6.2', require: false

  gem 'simplecov', '0.15.1'

  # TODO:  refactor tests to delete this
  gem 'rails-controller-testing', '1.0.2' # for assert_template  and assigns
end
