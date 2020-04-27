# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # OmniAuth.config.full_host = Rails.env.production? ? 'https://domain.com' : 'http://localhost:3000'
    # OmniAuth.config.full_host = 'http://localhost:3000'
    OmniAuth.config.test_mode = true

    @user_name = 'John Doe'
    @user_email = 'john.doe@nowhere.com'
  end

  test '#displayed_name show #name if present, #email otherwise' do
    email = 'my@rybickazlata.cz'
    name = 'Karel'
    u = User.new(email: email)
    assert_equal email, u.displayed_name
    u.name = name
    assert_equal name, u.displayed_name
  end

  def test_displayed_name_preffer_name_from_connection
    assert_equal connections(:bart_to_marge).name, users(:marge).displayed_name_for(users(:bart))

    connections(:bart_to_marge).destroy!

    assert_equal users(:marge).displayed_name, users(:marge).displayed_name_for(users(:bart))
  end

  def test_delete_identities_on_destroy
    identity_ids = users(:bart).identities.pluck(:id)
    assert 2, identities.size

    users(:bart).destroy

    assert User::Identity.where(id: identity_ids).blank?,
           "Defined identities not destroyed: #{User::Identity.where(id: identity_ids).to_yaml}"
    assert User::Identity.where(user_id: users(:bart).id).blank?,
           "Not all user's identities not destroyed: #{User::Identity.where(user_id: users(:bart).id).to_yaml}"
  end

  def test_get_main_idenity
    bart_base_identity = identities(:bart_identity_1)
    assert_equal bart_base_identity, users(:bart).main_identity
  end

  def test_got_admin
    assert User.new(email: 'porybny@rybickazlata.cz').admin? # admin is based on email (uniq)
    assert_not User.new(email: 'orybny@rybickazlata.cz').admin?

    adm = create_test_user!(email: 'porybny@rybickazlata.cz')
    assert_equal adm, User.admin
  end

  def test_create_local_identity_on_local_registration
    email = 'jonh.doe@example.com'
    assert User::Identity.local.where(email: email).blank?

    user = User.new(name: 'John Doe', email: email, password: 'my_Password10')
    user.save!

    assert_equal email, user.identities.local.first.email
  end

  def test_create_base_connection
    email = 'jonh.doe@example.com'

    assert Connection.base.where(email: email).blank?

    user = User.new(name: 'John Doe', email: email, password: 'my_Password10')
    user.save!

    assert email, user.base_connection.email
  end

  def test_know_all_connections
    ordered_connections = [connections(:bart_to_homer),
                           connections(:bart_to_lisa),
                           connections(:bart_to_marge),
                           connections(:bart_to_maggie),
                           connections(:bart_to_milhouse),
                           connections(:bart_base)].sort_by(&:name)
    assert_equal ordered_connections, users(:bart).connections.to_a
  end

  def test_knows_which_connections_are_friend_connections
    ordered_connections = [connections(:bart_to_homer),
                           connections(:bart_to_lisa),
                           connections(:bart_to_maggie),
                           connections(:bart_to_milhouse),
                           connections(:bart_to_marge)].sort_by(&:name)
    assert_equal ordered_connections, users(:bart).friend_connections.to_a
  end
end
