# frozen_string_literal: true

require 'url_regexp'

module ApplicationHelper
  THEMES = %w[light dark].freeze # anything else = follow the OS (prefers-color-scheme)

  # 'light', 'dark' or nil (system)
  def current_theme
    cookies[:theme] if THEMES.include?(cookies[:theme])
  end

  def set_page_title(page_title) # version page_title=(pg) does not work, it set local variable instead in view
    content_for(:title) { page_title }
  end

  def page_title
    content_for?(:title) ? content_for(:title) : (t('rybickazlata.name') + ' ' + t('rybickazlata.title'))
  end

  def header(text)
    tag.h3(text)
  end

  def form_submit_button(text = nil)
    render ButtonComponent.new(text, type: :submit, class: 'save', icon: (text ? nil : 'check'),
                                     aria_label: (text ? nil : 'OK'))
  end

  def form_next_button(text = nil)
    render ButtonComponent.new(text, type: :submit, class: 'next-step', icon: (text ? nil : 'arrow_forward'))
  end

  def add_new_button(text = nil)
    render ButtonComponent.new(text, type: :submit, variant: :tonal, class: 'new', icon: 'add')
  end

  # Button looking link (GET) or button_to form (other methods).
  # Legacy `data: { confirm:, 'confirm-yes':, confirm_no: }` is turned into the M3 confirm dialog.
  def button_link_to(title, url, options = {})
    opt = options.dup
    method = opt.delete(:method) || :get
    remote = opt.delete(:remote)
    data = (opt.delete(:data) || {}).to_h.transform_keys { |k| k.to_s.tr('_', '-') }
    confirm = if data['confirm']
                { message: data.delete('confirm'), yes: data.delete('confirm-yes'), no: data.delete('confirm-no') }
              end
    opt[:data] = data if data.present?

    render ButtonComponent.new(title, href: url, method: method, variant: :tonal, confirm: confirm,
                                      turbo: remote.present?, **opt)
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

  def unopened_notifications_count
    @unopened_notifications_count ||= user_signed_in? ? current_user.unopened_notification_count({}) : 0
  end
end
