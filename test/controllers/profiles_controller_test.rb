# frozen_string_literal: true

require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @bart = users(:bart)
    sign_in @bart
  end

  def test_my_page_is_setup_correctly
    get :my
    assert assigns(:user).present?
    assert_equal @bart, assigns(:user)

    assert assigns(:new_contact).present?
    assert_equal assigns(:new_contact).class, User::Identity::AsContact
  end
end
