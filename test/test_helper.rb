#RUN SINGLE TEST?  
#rake test TEST=test/models/identity_test.rb TESTOPTS="--name=test_can_be_created_from_auth_without_user -v"

#RUN ALL TESTS IN FILE?
#rake test TEST=test/models/identity_test.rb 

require "minitest/reporters"
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new]
#Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new]

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
   def create_test_user!(attrs={})
    user=User.new({name: "John Doe", email: "jonh.doe@test.com", password: "my_Password10"}.merge(attrs))
    user.skip_confirmation!
    user.save!
    user
  end
end

