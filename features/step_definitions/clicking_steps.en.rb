# frozen_string_literal: true

When(/^(?:I )?click on "([^"]*)"$/) do |co|
  click_link_or_button(co)
end

When(/^(?:I )?click on link "([^"]*)"$/) do |co|
  click_link(co)
end

When(/^(?:I )?click on button "([^"]*)"$/) do |co|
  click_button(co)
end

When(/^(?:I )?switch locale to "(.*?)"$/) do |locale|
  visit "/change_locale?locale=#{locale}"
  @locale = locale
end

When(/^I click on "(.*?)" in menu$/) do |text|
  within('div#main_menu') do
    click_link_or_button(text)
  end
end
