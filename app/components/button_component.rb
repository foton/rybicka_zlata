# frozen_string_literal: true

# M3 common button.
#
#   render ButtonComponent.new('Uložit', type: :submit)                       # <button type=submit>
#   render ButtonComponent.new('Upravit', href: edit_path, variant: :tonal)    # <a>
#   render ButtonComponent.new('Smazat', href: path, method: :delete,          # button_to form
#                              confirm: 'Opravdu?', variant: :text)
#
# Options: method:, type: (:button), params: ({}), confirm: (String or {message:, yes:, no:}),
# turbo: (false), aria_label:; everything else (class:, id:, data:, ...) goes to the element.
#
# Non-GET links become real forms (button_to), so they work without any JS.
# confirm: asks via the M3 confirm dialog (data-rz-confirm on plain forms,
# data-turbo-confirm when the form is submitted by Turbo, i.e. turbo: true).
class ButtonComponent < ApplicationComponent
  VARIANTS = %i[filled tonal outlined text elevated menu_item].freeze
  OPTIONS = %i[method type params confirm turbo aria_label].freeze

  def initialize(label = nil, variant: :filled, icon: nil, href: nil, **options)
    super()
    raise ArgumentError, "unknown variant #{variant}" unless VARIANTS.include?(variant)

    @label = label
    @variant = variant
    @icon = icon
    @href = href
    @options = options.slice(*OPTIONS)
    @html = options.except(*OPTIONS)
  end

  def call
    if form?
      helpers.button_to(@href, method: http_method, params: @options.fetch(:params, {}),
                               form: form_attributes, **element_attributes) { inner }
    elsif @href
      link_to(@href, **element_attributes) { inner }
    else
      tag.button(type: @options.fetch(:type, :button), **element_attributes) { inner }
    end
  end

  private

  def http_method
    @options[:method]&.to_sym
  end

  def form?
    @href.present? && http_method.present? && http_method != :get
  end

  def inner
    safe_join([(render(IconComponent.new(@icon)) if @icon),
               (tag.span(@label, class: 'rz-button__label') if @label)])
  end

  def element_attributes
    attrs = @html.except(:class, :data)
    attrs[:class] = css_classes
    attrs[:data] = @html[:data] if @html[:data].present?
    attrs[:aria] = { label: @options[:aria_label] } if @options[:aria_label]
    attrs
  end

  def css_classes
    return ['rz-menu__item', @html[:class]] if @variant == :menu_item

    ['rz-button', "rz-button--#{@variant}", ('rz-button--icon-only' if @icon && @label.blank?),
     @html[:class]]
  end

  def form_attributes
    turbo = @options[:turbo]
    data = { turbo: (turbo ? 'true' : nil) }
    data[turbo ? :turbo_confirm : :rz_confirm] = confirm[:message] if confirm
    data.merge!(confirm_yes: confirm[:yes], confirm_no: confirm[:no]) if confirm
    { class: (@variant == :menu_item ? 'rz-menu__form' : 'rz-button-form'), data: data.compact }
  end

  def confirm
    value = @options[:confirm]
    return if value.blank?

    value.is_a?(Hash) ? value : { message: value }
  end
end
