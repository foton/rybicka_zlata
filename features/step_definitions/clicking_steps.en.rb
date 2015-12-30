#encoding: utf-8

When /^(?:I )?click on "([^"]*)"$/ do |co|
  click_link_or_button(co)
end

When /^(?:I )?click on link "([^"]*)"$/ do |co|
  click_link(co)
end

When /^(?:I )?click on button "([^"]*)"$/ do |co|
  click_button(co)
end

When(/^(?:I )?switch locale to "(.*?)"$/) do |locale|
   visit "/change_locale?locale=#{locale}" 
   @locale=locale
end
