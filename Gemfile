source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
gem 'pg' #PostgreSQL kvuli Heroku


#Material theme for Bootstrap
#gem 'bootstrap-material-design'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks' #they blocked MDL javascripts when clicked od link to RybZl page

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
#gem 'sdoc', '~> 0.4.0', group: :doc

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#authorization
gem 'devise'
gem 'devise-i18n'
gem 'omniauth-oauth2', '~> 1.3.1'  #version 1.4.0 have 'uri_mismatch error'
#gem 'omniauth-gplus'
gem "omniauth-google-oauth2"
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'omniauth-linkedin-oauth2'
#TODO: maybe? gem 'i18n-tasks', '~> 0.9.2'

#gem 'active_type'  #not yet used, but may be VERY usefull


group :development, :test do

  #Coffee-rails and Uglifier demands ExecJS, which require JS runtime. So I pick up Rubyracer
  #Production is on Heroku where they have NODE, so no rubyracer is needed there https://devcenter.heroku.com/articles/rails-asset-pipeline
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby

  # using minitest which commes with rails         gem "rspec-rails"
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem "pry-rails" # pry misto IRB v rails console
  gem "pry-byebug" #debugging with pry on ruby 2 ('step','next','finish','continue')
  gem "minitest-reporters" #better formatted output of Minitest
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem "cucumber-rails", require: false
  gem 'database_cleaner', require: false
  gem "capybara-webkit", require: false   #need QT installed  for Ubuntu: sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
end

