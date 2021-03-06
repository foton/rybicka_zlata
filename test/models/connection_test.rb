# frozen_string_literal: true

require 'test_helper'

class ConnectionTest < ActiveSupport::TestCase
  def setup
    @connection = connections(:bart_to_lisa)
    assert @connection.valid?
    @bart = users(:bart)
    @lisa = users(:lisa)
  end

  def test_cannot_be_without_email
    assert_not Connection.new.valid?
    @connection.email = nil
    assert_not @connection.valid?
    assert_equal ['je povinná položka', 'není platná hodnota'], @connection.errors[:email]

    @connection.email = ''
    assert_not @connection.valid?
    assert_equal ['je povinná položka', 'není platná hodnota'], @connection.errors[:email]

    @connection.email = 'not_valid@email_adress'
    assert_not @connection.valid?
    assert_equal ['není platná hodnota'], @connection.errors[:email]
  end

  def test_cannot_be_without_owner
    @connection.owner_id = nil
    assert_not @connection.valid?
    assert_equal ['je povinná položka'], @connection.errors[:owner]

    @connection.owner_id = (User.last.id + 1)
    assert_not @connection.valid?
    assert_equal ['je povinná položka'], @connection.errors[:owner]
  end

  def test_cannot_be_without_name
    @connection.name = nil
    assert_not @connection.valid?
    assert_equal ['je povinná položka', 'není platná hodnota'], @connection.errors[:name]

    @connection.name = ''
    assert_not @connection.valid?
    assert_equal ['je povinná položka', 'není platná hodnota'], @connection.errors[:name]

    @connection.name = 'ak'
    assert_not @connection.valid?
    assert_equal ['není platná hodnota'], @connection.errors[:name]

    @connection.name = 'ako' # three chars is enough
    assert @connection.valid?

    @connection.name = ' ak'
    assert_not @connection.valid?
    assert_equal ['není platná hodnota'], @connection.errors[:name]

    @connection.name = 'ak '
    assert_not @connection.valid?
    assert_equal ['není platná hodnota'], @connection.errors[:name]

    @connection.name = 'a k' # three chars is enough, space between is OK
    assert @connection.valid?
  end

  def test_basename_cannot_be_used_for_non_base_connection
    @connection.name = Connection::BASE_CONNECTION_NAME
    assert_not @connection.valid?
    assert_equal ['není platná hodnota'], @connection.errors[:name]

    # make it base connection
    @connection.friend_id = @connection.owner_id
    @connection.email = @bart.email

    assert @connection.valid?
  end

  def test_can_be_without_to_user
    @connection.friend_id = nil
    assert @connection.valid?
  end

  def test_should_assign_existing_user_according_to_user_email
    # user.email should be also in identities! (user after_save callback)

    @connection = Connection.new(name: 'Traveling Ford', email: @lisa.email, owner_id: @bart.id)
    assert @connection.valid?
    assert_equal @lisa.id, @connection.friend_id
  end

  def test_should_assign_existing_user_according_to_email_from_identities
    # user's emails are searched in identities
    email = 'please@stop.me'
    @lisa.identities << User::Identity.local.create(email: email)

    @connection = Connection.new(name: 'Traveling Ford', email: email, owner_id: @bart.id)
    assert @connection.valid?
    assert_equal @lisa.id, @connection.friend_id
  end

  def test_show_existing_reg_user_in_full_name
    # 'friendsip.name + [friend.name]'        if friend is assigned
    assert_equal 'Liiiisaaa [Lisa Marie Simpson]: lisa@simpsons.com',
                 @connection.fullname
  end

  def test_show_not_yet_assigned_reg_user_in_full_name
    @connection.friend_id = nil
    assert_equal 'Liiiisaaa [???]: lisa@simpsons.com', @connection.fullname
  end

  def test_show_base_connection_as_author_in_full_name
    assert_equal 'Autor přání [Lisa Marie Simpson]: lisa@simpsons.com', @lisa.base_connection.fullname
  end

  def test_do_downcase_email
    connection = Connection.new(name: 'Simon', email: 'Simon@SayS.com', owner_id: @bart.id)
    assert_equal 'simon@says.com', connection.email
  end
end
