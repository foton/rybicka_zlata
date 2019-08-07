# frozen_string_literal: true

require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @group_family = groups(:bart_family)
    assert_equal 3, @group_family.connections.size
  end

  def test_cannot_be_without_user
    @group_family.user_id = nil
    assert_not @group_family.valid?
    assert_equal ['je povinná položka'], @group_family.errors[:user]

    @group_family.user_id = (User.last.id + 1)
    assert_not @group_family.valid?
    assert_equal ['je povinná položka'], @group_family.errors[:user]
  end

  def test_cannot_be_without_name
    @group_family.name = nil
    assert_not @group_family.valid?
    assert_equal ['je povinná položka'], @group_family.errors[:name]

    @group_family.name = ''
    assert_not @group_family.valid?
    assert_equal ['je povinná položka'], @group_family.errors[:name]
  end

  def test_can_be_without_connections
    @group_family.connections = []
    assert @group_family.valid?
  end

  def test_can_add_connections
    bart = @group_family.user

    con1 = Connection.new(name: 'con1', email: 'con1@group.cz', owner_id: bart.id)
    con2 = Connection.new(name: 'con2', email: 'con2@group.cz', owner_id: bart.id)
    con3 = Connection.new(name: 'con3', email: 'con3@group.cz', owner_id: bart.id)
    @group_family.connections = []

    @group_family.connections << con1
    assert_equal [con1], @group_family.connections

    @group_family.connections << con2
    assert_equal [con1, con2], @group_family.connections

    @group_family.connections = [con2, con3]
    assert_equal [con2, con3], @group_family.connections
  end

  def test_can_remove_connections
    conn = connections(:bart_to_lisa)
    assert @group_family.connections.include?(conn)

    @group_family.connections.delete(conn)

    assert_not @group_family.connections.reload.include?(conn)
    assert @group_family.user.connections.include?(conn) # connection should not be destroyed, just deleted from group
  end
end
