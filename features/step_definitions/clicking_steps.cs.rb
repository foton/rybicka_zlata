#encoding: utf-8

When /^kliknu na "([^"]*)"$/ do |co|
  click_link_or_button(co)
end

When /^kliknu na odkaz "([^"]*)"$/ do |co|
  click_link(co)
end

When /^kliknu na tlačítko "([^"]*)"$/ do |co|
  click_button(co)
end

When(/^přepnu na češtinu$/) do
  visit "/change_locale?locale=cs"  
end
