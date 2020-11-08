# frozen_string_literal: true

When(/^I open last email for "(.*?)"$/) do |email_addr|
  @email = (ActionMailer::Base.deliveries.select { |em| em.to.include?(email_addr) }).last
  @email.body # to raise error if @email is nil
end

require 'nokogiri'
# require 'uri'

When(/^click on link "(.*?)" in email$/) do |link_text|
  doc = Nokogiri::HTML.parse(@email.body.encoded)
  links = doc.css('a').select { |link| link.text == link_text }
  if links.empty?
    raise "No link with text '#{link_text} found in #{@email.body.encoded}"
  elsif links.size > 1
    raise "More than 1 link with text '#{link_text} found in #{@email.body.encoded}"
  else
    uri = URI.parse(links.first['href']) # with localhost => "http://localhost:3000/users/confirmation?confirmation_token=z8-qzo-uhreXaVu7CXXA
  end

  relative_url = uri.to_s
  relative_url = relative_url.gsub("#{uri.scheme}://", '') if uri.scheme.present?
  relative_url = relative_url.gsub(uri.userinfo, '') if uri.userinfo.present?
  relative_url = relative_url.gsub(uri.host, '') if uri.host.present?
  relative_url = relative_url.gsub(":#{uri.port}", '') if uri.port.present?

  visit relative_url
end
