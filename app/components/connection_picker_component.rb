# frozen_string_literal: true

# Picker of the user's connections, replacing the drag & drop panels.
#
# mode :roles  (author's wish form) - every contact has a segmented button
#              Obdarovaný | — | Dárce; submits `<field_name>[<connection id>]=donee|none|donor`
# mode :toggle (co-donee's donors, group members) - every contact has a checkbox;
#              submits `<field_name>[]=<connection id>` for the checked ones
#
# Groups are bulk helpers only (not submitted): choosing a role for a group (or checking it)
# sets all its members; a group whose members differ is shown as "partial".
# Search, filter chips, counts and group bulk actions are done by <rz-connection-picker>
# (elements/rz_connection_picker.js); without JS the plain radios / checkboxes still work.
class ConnectionPickerComponent < ApplicationComponent
  ROLES = %i[donee none donor].freeze

  Row = Data.define(:id, :label, :state)
  GroupRow = Data.define(:id, :label, :member_ids, :state)

  def initialize(connections:, field_name:, mode: :roles, groups: [], roles: {}, # rubocop:disable Metrics/ParameterLists
                 selected_ids: [], toggle_label: nil, include_hidden: false, id: 'user_connections')
    super()
    @mode = mode
    @field_name = field_name
    @toggle_label = toggle_label
    @include_hidden = include_hidden
    @id = id
    @rows = build_rows(connections, roles, selected_ids)
    @groups = build_groups(groups)
  end

  attr_reader :rows, :groups, :mode, :id

  def roles? = mode == :roles

  def filters
    roles? ? %i[all donee donor none] : %i[all selected unselected]
  end

  def counts
    rows.group_by(&:state).transform_values(&:size)
  end

  def input_name(row)
    roles? ? "#{@field_name}[#{row.id}]" : "#{@field_name}[]"
  end

  def include_hidden? = @include_hidden && !roles?

  def hidden_name = "#{@field_name}[]"

  def role_options
    [[:donee, t('rybickazlata.connection_picker.roles.donee')],
     [:none, '—', t('rybickazlata.connection_picker.roles.none')],
     [:donor, t('rybickazlata.connection_picker.roles.donor')]]
  end

  def toggle_label
    @toggle_label || t('rybickazlata.connection_picker.selected')
  end

  private

  # assigned contacts first, then alphabetically
  def build_rows(connections, roles, selected_ids)
    rows = connections.map do |conn|
      Row.new(id: conn.id, label: conn.fullname, state: initial_state(conn, roles, selected_ids))
    end
    rows.sort_by { |row| [assigned?(row) ? 0 : 1, row.label.downcase] }
  end

  def initial_state(conn, roles, selected_ids)
    return (roles[conn.id] || :none).to_sym if roles?

    selected_ids.include?(conn.id) ? :selected : :unselected
  end

  def assigned?(row)
    %i[none unselected].exclude?(row.state)
  end

  # only members listed in the picker count; a group without such members is skipped
  def build_groups(groups)
    states = rows.to_h { |row| [row.id, row.state] }
    groups.filter_map do |group|
      member_ids = group.connections.map(&:id) & states.keys
      next if member_ids.empty?

      group_row(group, member_ids, states)
    end
  end

  def group_row(group, member_ids, states)
    GroupRow.new(id: group.id, label: "#{group.name} (#{member_ids.size})", member_ids: member_ids,
                 state: group_state(member_ids.map { |mid| states[mid] }))
  end

  def group_state(member_states)
    member_states.uniq.one? ? member_states.first : :partial
  end
end
