# frozen_string_literal: true

module Layout
  # Page footer with contact and privacy links.
  class FooterComponent < ApplicationComponent
    def call
      tag.footer(class: 'rz-footer') do
        safe_join([tag.span(t('rybickazlata.name'), class: 'rz-footer__name'),
                   link_to(about_label, helpers.about_path, class: 'rz-footer__link'),
                   link_to(t('privacy_policy.title'), helpers.privacy_policy_path, class: 'rz-footer__link')])
      end
    end

    private

    def about_label
      "#{t('rybickazlata.static.about.title')} / #{t('rybickazlata.static.contact_us.title')}"
    end
  end
end
