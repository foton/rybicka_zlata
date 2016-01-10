#encoding: utf-8

When /^(?:vyplním|zapíšu) do (?:položky )?"([^"]*)" text "([^"]*)"$/ do |polozka, text|
  fill_in(polozka, :with => text)
end

When /^vyberu "([^"]*)" z nabídky "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

Pak(/^změním "(.*?)" na "(.*?)"$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Když(/^zadám další adresu "(.*?)"$/) do |adr|
  fill_in("Další adresa", with: adr)
end