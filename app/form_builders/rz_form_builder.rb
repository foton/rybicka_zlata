# frozen_string_literal: true

# Form builder rendering Material 3 fields (outlined text fields, selects, checkboxes, switches).
#
#   <%= form_with model: @connection, builder: RzFormBuilder do |f| %>
#     <%= f.text_field :name, label: t('...') %>
#     <%= f.email_field :email, supporting_text: 'nepovinné' %>
#     <%= f.switch :remember_me %>
#     <%= f.submit 'Uložit' %>
#   <% end %>
#
# Field methods keep Rails' signatures; extra keyword options:
#   label:            label text (default: Rails' translated attribute name), false = no label
#   supporting_text:  hint under the field (replaced by the validation error, if any)
#   error:            true = show the field as invalid even without a validation error
# Labels float via CSS only (:placeholder-shown), so no JavaScript is needed.
# Validation errors of the attribute mark the field (aria-invalid) and are shown under it.
class RzFormBuilder < ActionView::Helpers::FormBuilder # rubocop:disable Metrics/ClassLength
  TEXT_FIELDS = %i[text_field email_field password_field number_field telephone_field url_field
                   search_field date_field].freeze

  CHECK_BOX = ActionView::Helpers::FormBuilder.instance_method(:check_box)

  TEXT_FIELDS.each do |field_type|
    define_method(field_type) do |method, options = {}|
      text_like_field(method, options) { |opts| super(method, opts) }
    end
  end

  def text_area(method, options = {})
    text_like_field(method, options, modifier: 'textarea') { |opts| super(method, opts) }
  end

  def select(method, choices = nil, options = {}, html_options = {}, &)
    select_field(method, html_options) { |opts| super(method, choices, options, opts, &) }
  end

  def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
    select_field(method, html_options) { |opts| super(method, priority_zones, options, opts) }
  end

  def check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
    toggle_field('rz-checkbox', method, options) do |opts|
      super(method, opts, checked_value, unchecked_value)
    end
  end

  # M3 switch: a checkbox with role="switch"
  def switch(method, options = {}, checked_value = '1', unchecked_value = '0')
    toggle_field('rz-switch', method, options.merge(role: 'switch')) do |opts|
      CHECK_BOX.bind_call(self, method, opts, checked_value, unchecked_value)
    end
  end

  # Submit as an M3 button (<button type="submit">); options: variant:, icon:, class:, id:, data:
  def submit(value = nil, options = {})
    if value.is_a?(Hash)
      options = value
      value = nil
    end
    label = value || submit_default_value
    @template.render ButtonComponent.new(label, type: :submit, name: options.delete(:name),
                                                **options.reverse_merge(variant: :filled))
  end

  private

  def text_like_field(method, options, modifier: nil)
    mark_error(method) if options.delete(:error)
    label_text = options.delete(:label)
    supporting = supporting_for(method, options.delete(:supporting_text))
    opts = field_options(method, options, 'rz-text-field__input', supporting)
    opts[:placeholder] ||= ' ' # :placeholder-shown drives the floating label
    field = yield(opts)

    wrapper('rz-text-field', method, modifier:, has_label: label_text != false) do
      @template.safe_join([field, field_label(method, label_text, 'rz-text-field__label'),
                           supporting_tag(method, supporting)].compact)
    end
  end

  def select_field(method, html_options)
    label_text = html_options.delete(:label)
    supporting = supporting_for(method, html_options.delete(:supporting_text))
    field = yield(field_options(method, html_options, 'rz-text-field__input rz-select__input',
                                supporting))

    wrapper('rz-text-field', method, modifier: 'select', has_label: label_text != false) do
      @template.safe_join([field, field_label(method, label_text, 'rz-text-field__label'),
                           select_icon,
                           supporting_tag(method, supporting)].compact)
    end
  end

  def select_icon
    @template.render(IconComponent.new('arrow_drop_down', classes: 'rz-select__icon'))
  end

  def toggle_field(base, method, options)
    label_text = options.delete(:label)
    supporting = supporting_for(method, options.delete(:supporting_text))
    input = yield(options.merge(class: "#{base}__input"))
    toggle_wrapper(base, method, input, label_text, supporting)
  end

  def field_options(method, options, css_class, supporting)
    opts = options.dup
    opts[:class] = [css_class, opts[:class]].compact.join(' ')
    opts[:aria] = (opts[:aria] || {}).merge(invalid: true) if error?(method)
    opts[:aria] = (opts[:aria] || {}).merge(describedby: supporting_id(method)) if supporting
    opts
  end

  def wrapper(base, method, modifier: nil, has_label: true, &)
    classes = [base, ("#{base}--#{modifier}" if modifier), ("#{base}--error" if error?(method)),
               ("#{base}--no-label" unless has_label), 'field']
    @template.tag.div(class: classes.compact, &)
  end

  def toggle_wrapper(base, method, input, label_text, supporting)
    classes = [base, ("#{base}--error" if error?(method)), 'field']
    @template.tag.div(class: classes.compact) do
      label = label(method, class: "#{base}__label") do |builder|
        @template.safe_join([input,
                             @template.tag.span(label_text || builder.translation,
                                                class: "#{base}__text")])
      end
      @template.safe_join([label, supporting_tag(method, supporting)].compact)
    end
  end

  def field_label(method, label_text, css_class)
    return if label_text == false

    label(method, label_text, class: css_class)
  end

  def supporting_for(method, text)
    messages = object.respond_to?(:errors) ? object.errors[method] : []
    messages.present? ? messages.to_sentence : text
  end

  def supporting_tag(method, text)
    return if text.blank?

    @template.tag.div(text, id: supporting_id(method), class: 'rz-field__supporting')
  end

  def supporting_id(method)
    "#{field_id(method)}_supporting"
  end

  def error?(method)
    forced_error?(method) || (object.respond_to?(:errors) && object.errors[method].present?)
  end

  # `error: true` marks a field invalid without a validation error on the object
  # (e.g. Devise's failed sign in only sets flash[:alert])
  def mark_error(method)
    (@forced_errors ||= Set.new) << method
  end

  def forced_error?(method)
    @forced_errors&.include?(method)
  end
end
