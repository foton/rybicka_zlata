# frozen_string_literal: true

# M3 segmented button, single select, made of native radio buttons (works without JS,
# arrow keys move the selection).
#
#   render SegmentedButtonComponent.new(name: 'wish[connection_roles][12]', label: 'Dad',
#     options: [[:donee, 'Obdarovaný'], [:none, '—', 'Nepřiřazen'], [:donor, 'Dárce']],
#     value: :donor)
#
# options: [value, visible text, accessible text (optional, when the visible one is a symbol)]
class SegmentedButtonComponent < ApplicationComponent
  def initialize(name:, label:, options:, value: nil)
    super()
    @name = name
    @label = label
    @options = options
    @value = value&.to_s
  end

  def call
    tag.div(class: 'rz-segmented', role: 'radiogroup', aria: { label: @label }) do
      safe_join(@options.map { |option| segment(*option) })
    end
  end

  private

  def segment(value, text, accessible_text = nil)
    tag.label(class: ['rz-segmented__segment', "rz-segmented__segment--#{value}"]) do
      safe_join([
                  tag.input(type: 'radio', class: 'rz-segmented__input', name: @name, value: value,
                            checked: @value == value.to_s),
                  render(IconComponent.new('check', classes: 'rz-segmented__check')),
                  segment_text(text, accessible_text)
                ])
    end
  end

  def segment_text(text, accessible_text)
    return tag.span(text, class: 'rz-segmented__text') unless accessible_text

    tag.span(class: 'rz-segmented__text') do
      tag.span(text,
               aria: { hidden: true }) + tag.span(accessible_text, class: 'rz-visually-hidden')
    end
  end
end
