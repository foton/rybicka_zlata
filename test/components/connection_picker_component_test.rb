# frozen_string_literal: true

require 'test_helper'

class ConnectionPickerComponentTest < ViewComponent::TestCase
  def setup
    @bart = users(:bart)
    @conns = @bart.friend_connections.to_a
    @homer = connections(:bart_to_homer)
    @lisa = connections(:bart_to_lisa)
  end

  def test_roles_mode_renders_segmented_radios_per_contact
    render_picker(roles: { @homer.id => :donor, @lisa.id => :donee })

    assert_selector 'rz-connection-picker#user_connections[data-mode="roles"]'
    assert_selector %(#{radio(@homer)}[value="donor"][checked])
    assert_selector %(#{radio(@lisa)}[value="donee"][checked])
    assert_selector %(#{radio((@conns - [@homer, @lisa]).first)}[value="none"][checked])
  end

  def test_assigned_contacts_are_listed_first
    render_picker(roles: { @lisa.id => :donee })

    assert_equal @lisa.id.to_s, page.first('.rz-picker__row[data-id]')['data-id']
  end

  def test_counts_in_summary
    render_picker(roles: { @homer.id => :donor, @lisa.id => :donor })

    assert_selector '[data-count="donor"]', text: '2'
    assert_selector '[data-count="donee"]', text: '0'
    assert_selector '[data-count="none"]', text: (@conns.size - 2).to_s
  end

  def test_group_state_is_role_of_all_members_or_partial
    group = groups(:bart_family)
    member_ids = group.connections.map(&:id) & @conns.map(&:id)

    render_picker(groups: [group], roles: member_ids.index_with { :donor })
    group_row = %(.rz-picker__row[data-group][data-member-ids="#{member_ids.join(',')}"])
    assert_selector %(#{group_row}[data-state="donor"])
    assert_selector %(input[name="picker_groups[#{group.id}]"][value="donor"][checked])

    render_picker(groups: [group], roles: { member_ids.first => :donee })
    assert_selector '.rz-picker__row[data-group][data-state="partial"]'
  end

  def test_toggle_mode_renders_checkboxes_and_hidden_blank
    render_inline(ConnectionPickerComponent.new(mode: :toggle, connections: @conns,
                                                include_hidden: true, selected_ids: [@homer.id],
                                                field_name: 'group[connection_ids]'))

    checkbox = 'input[type="checkbox"][name="group[connection_ids][]"]'
    assert_selector 'input[type="hidden"][name="group[connection_ids][]"][value=""]', visible: :all
    assert_selector %(#{checkbox}[value="#{@homer.id}"][checked])
    assert_selector "#{checkbox}:not([checked])", count: @conns.size - 1
    assert_selector '.rz-chip[data-filter="selected"]'
  end

  private

  def render_picker(groups: [], roles: {})
    render_inline(ConnectionPickerComponent.new(connections: @conns, groups: groups, roles: roles,
                                                field_name: 'wish[connection_roles]'))
  end

  def radio(conn)
    %(input[type="radio"][name="wish[connection_roles][#{conn.id}]"])
  end
end
