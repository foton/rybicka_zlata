# frozen_string_literal: true

# Material Symbols icon (decorative; give the surrounding control an accessible label).
#   render IconComponent.new("menu")
class IconComponent < ApplicationComponent
  def initialize(name, filled: false, classes: nil)
    super()
    @name = name
    @filled = filled
    @classes = classes
  end

  def call
    tag.span(@name, class: css_classes, aria: { hidden: true }, translate: 'no')
  end

  private

  def css_classes
    ['rz-icon', 'material-symbols-outlined', ('rz-icon--filled' if @filled), @classes]
  end
end
