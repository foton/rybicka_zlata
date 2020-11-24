# frozen_string_literal: true

require 'url_regexp'

module ApplicationHelper
  def set_page_title(page_title) # version page_title=(pg) does not work, it set local variable instead in view
    content_for(:title) { page_title }
  end

  def page_title
    content_for?(:title) ? content_for(:title) : (t('rybickazlata.name') + ' ' + t('rybickazlata.title'))
  end

  def mdl_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', warning: 'alert-warning', alert: 'alert-warning', notice: 'alert-info' }[flash_type.to_sym] || flash_type.to_s
  end

  # https://gist.github.com/suryart/7418454
  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(tag.div(message, class: "alert #{mdl_class_for(msg_type)} mdl-cell mdl-cell--12-col") do
               # concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
               concat message
             end)
    end
    nil
  end

  def header(text)
    tag.h3(text)
  end

  def switch_for(f_builder, method, label_text = nil, options = {}, html_options = {}, checked_value = '1', unchecked_value = '0')
    if label_text.blank? && f_builder.object.is_a?(ActiveRecord::Base)
      label_text = t("activerecord.attributes.#{f_builder.object.class.name.downcase}.#{method}")
    end

    f_builder.label(method, nil, options.merge(class: 'mdl-switch mdl-js-switch mdl-js-ripple-effect')) do
      concat(f_builder.check_box(method, options.merge(html_options.merge(class: 'mdl-switch__input')), checked_value, unchecked_value))
      concat(tag.span(label_text, class: 'mdl-switch__label'))
    end
  end

  def checkbox_mdl_tag(tag_id, label_text, check_status, checked_value = '1', _unchecked_value = '0', options = {})
    labl_opt = options.dup
    labl_opt[:class] = "#{options[:class]} mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect"
    check_opt = options.dup
    check_opt[:class] = "#{options[:class]} mdl-checkbox__input"
    span_opt = options.dup
    span_opt[:class] = "#{options[:class]} mdl-checkbox__label"

    label_tag(nil, labl_opt) do
      concat(check_box_tag(tag_id, checked_value, check_status, check_opt))
      concat(tag.span(label_text, span_opt))
    end
  end

  def form_submit_button(text = nil)
    button_tag(class: 'save ' + button_mdl_classes) do
      text || '<i class="material-icons">check</i>'.html_safe
    end
  end

  def form_next_button(text = nil)
    button_tag(class: 'next-step ' + button_mdl_classes) do
      text || '<i class="material-icons">forward</i>'.html_safe
    end
  end

  def add_new_button(text = nil)
    button_tag(class: 'new ' + button_mdl_classes) do
      text || '<i class="material-icons">add</i>'.html_safe
    end
  end

  def button_link_to(title, url, options = {})
    opt = { method: :get, class: '' }.merge(options)
    # opt_4_helper={method: opt[:method], data: opt[:data], remote: opt[:remote]}
    # html_opt=opt.dup
    # html_opt.delete(:method)
    # html_opt.delete(:data)
    # html_opt.delete(:remote)
    opt[:class] = opt[:class] + ' mdl-list__item-secondary-action ' + button_mdl_classes

    # link_to( title, url, method: opt[:method], data: opt[:data], id: opt[:id], class: opt[:html_class]+" mdl-list__item-secondary-action "+button_mdl_classes)
    link_to(title, url, opt)
  end

  # convert char '\n' to '<br />'
  # and  URIs to clickable links
  def to_html(str)
    # cutoff URIs
    uri_placeholder = 'LINK_PLAC3HOLD3R_HERE'
    uris = str.scan(Regexp::PERFECT_URL_PATTERN)
    htmls = str.gsub(Regexp::PERFECT_URL_PATTERN, uri_placeholder)

    # escape other text
    htmls = CGI.escapeHTML(htmls)

    # substitute newlines
    htmls = htmls.gsub("\n", '<br />')

    # put URIs back as clickable links
    uris.each do |uri|
      htmls = htmls.sub(uri_placeholder, short_link_from_uri(uri.join('')))
    end

    htmls
  end

  def short_link_from_uri(uri)
    text = if uri.size < 50
             uri
           else
             I18n.t('uri_shortened', uri_short: URI.parse(uri).host)
           end
    link_to(text, uri)
  end

  def label_and_value(label, value)
    ('<span class= "label">' + html_escape(label.to_s) + '</span>: ' \
    '<span class="field_value">' + html_escape(value.to_s) + '</span>').html_safe
  end

  private

  def button_mdl_classes
    'mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--colored'
  end
end
