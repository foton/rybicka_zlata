# frozen_string_literal: true

ruby '2.5.3'
source 'https://rubygems.org'

# webserver https://devcenter.heroku.com/articles/ruby-default-web-server
# gem 'puma'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg', '1.1.4'
gem 'rails', '5.2.2.1'

# Use Puma as the app server
gem 'puma', '3.12.0', '~> 3.11'

# Use SCSS for stylesheets
gem 'sass-rails', '5.0.7'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '4.1.20'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '4.2.2'

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.3.3'

# authorization
gem 'devise', '4.7.1'
gem 'devise-i18n', '1.8.1'
gem 'omniauth-facebook', '5.0.0'
gem 'omniauth-github', '1.3.0'
gem 'omniauth-google-oauth2', '0.6.0'
gem 'omniauth-linkedin-oauth2', '1.0.0'
gem 'omniauth-oauth2', '1.6.0'
gem 'omniauth-twitter', '1.4.0'
gem 'omniauth-rails_csrf_protection', '~> 0.1.2'

gem 'sendgrid', '1.2.4' # for sending emails in production

group :development, :test do
  # Coffee-rails and Uglifier demands ExecJS, which require JS runtime.
  # So I pick up MiniRacer
  # Production is on Heroku where they have NODE, so no rubyracer is needed there https://devcenter.heroku.com/articles/rails-asset-pipeline
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'mini_racer', '0.2.4', platforms: :ruby

  gem 'pry-byebug', '3.6.0' # debugging with pry on ruby 2 ('step','next','finish','continue')
  gem 'pry-rails', '0.3.9' # pry in Rails console instead IRB

  gem 'minitest-reporters', '1.3.6' # better formatted output of Minitest

  # managing secrets
  gem 'dotenv-heroku', '0.0.1' # upload secrets to HEROKU as ENV variables
  gem 'dotenv-rails', '2.6.0' # loads secrets from .env file into ENV variables
end

group :development do
  # speeds up development by keeping your application running in the background.
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1', '~> 2.0.0'

  # style check, allways learning best practicies
  gem 'rubocop', '0.63.0', require: false
end

group :test do
  gem 'capybara-webkit', '1.15.1', require: false
  # ^ need QT installed for Ubuntu:
  # sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base
  # sudo apt-get install gstreamer1.0-tools gstreamer1.0-x
  gem 'cucumber', '3.1.2'
  gem 'cucumber-rails', '1.6.0', require: false
  gem 'database_cleaner', '1.7.0', require: false

  # TODO:  refactor tests to delete this
  gem 'rails-controller-testing', '1.0.4' # for assert_template  and assigns
end
