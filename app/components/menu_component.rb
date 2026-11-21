# frozen_string_literal: true

# M3 menu opened by an icon button; native popover anchored to the button
# (CSS anchor positioning), light-dismiss and Esc for free, no JavaScript.
#
#   render MenuComponent.new(label: 'Další akce') do |menu|
#     menu.with_item { link_to 'Upravit', edit_path, class: 'rz-menu__item' }
#   end
class MenuComponent < ApplicationComponent
  renders_many :items

  def initialize(label:, icon: 'more_vert', classes: nil)
    super()
    @label = label
    @icon = icon
    @classes = classes
    @uid = "rz-menu-#{SecureRandom.hex(4)}"
  end

  def render?
    items?
  end

  private

  attr_reader :label, :icon, :classes, :uid
end
