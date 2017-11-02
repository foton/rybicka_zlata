# frozen_string_literal: true

require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @user = create_test_user!
    @connections = []
    for email in ['mama@family.cz', 'tata@family.cz', 'kaja@pratele.cz', 'jana@pratele.cz']
      conn = Connection.new(name: email.split('@').first, email: email, owner_id: @user.id)
      assert conn.valid?
      @connections << conn
    end

    @group_family = Group.new(name: 'Rodina', user_id: @user.id)
    @group_family.connections = @connections[0..1]

    @group_friends = Group.new(name: 'Kámoši', user_id: @user.id)
    @group_friends.connections = @connections[2..-1]

    @group_mans = Group.new(name: 'Chlapi sobě', user_id: @user.id)
    @group_friends.connections = @connections[1..2]
  end

  def test_cannot_be_without_user
    @group_family.user_id = nil
    refute @group_family.valid?
    assert_equal ['je povinná položka'], @group_family.errors[:user]

    @group_family.user_id = (User.last.id + 1)
    refute @group_family.valid?
    assert_equal ['je povinná položka'], @group_family.errors[:user]
  end

  def test_cannot_be_without_name
    @group_family.name = nil
    refute @group_family.valid?
    assert_equal ['je povinná položka'], @group_family.errors[:name]

    @group_family.name = ''
    refute @group_family.valid?
    assert_equal ['je povinná položka'], @group_family.errors[:name]
  end

  def test_can_be_without_connections
    @group_family.connections = []
    assert @group_family.valid?
   end

  def test_can_add_connections
    con1 = Connection.new(name: 'con1', email: 'con1@group.cz', owner_id: @user.id)
    con2 = Connection.new(name: 'con2', email: 'con2@group.cz', owner_id: @user.id)
    con3 = Connection.new(name: 'con3', email: 'con3@group.cz', owner_id: @user.id)
    @group_family.connections = []

    @group_family.connections << con1

    assert_equal [con1], @group_family.connections

    @group_family.connections << con2

    assert_equal [con1, con2], @group_family.connections

    @group_family.connections = [con2, con3]

    assert_equal [con2, con3], @group_family.connections
  end

  def test_can_remove_connections
    conn = @connections[0]
    assert @group_family.connections.include?(conn)

    @group_family.connections.delete(conn)

    # this do not work (returning true evevn when there is no this conn in array): refute @group_family.connections.include?(conn)
    assert [], (@group_family.connections.select { |con| con.email == conn.email })
    @group_family.user.connections.include?(conn) # connection should not be destroyed, just deleted from association
  end
end
