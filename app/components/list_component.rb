# frozen_string_literal: true

# M3 list of objects with actions (wishes, connections, groups, contacts).
#
#   render ListComponent.new(empty_text: 'Nic tu není') do |list|
#     list.with_item(object: wish, user: @user, remote: true) do
#       render 'list_item_primary_content', object: wish
#     end
#   end
class ListComponent < ApplicationComponent
  renders_many :items, ListItemComponent

  def initialize(empty_text: nil, **html)
    super()
    @empty_text = empty_text
    @html = html
  end

  def call
    return tag.p(@empty_text, class: 'rz-list__empty') unless items?

    tag.ul(class: ['rz-list', @html[:class]], **@html.except(:class)) { safe_join(items) }
  end
end
