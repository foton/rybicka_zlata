# frozen_string_literal: true

When /^(?:vyplním|zapíšu) do (?:položky )?"([^"]*)" text "([^"]*)"$/ do |polozka, text|
  fill_in(polozka, with: text)
end

When /^vyberu "([^"]*)" z nabídky "([^"]*)"$/ do |value, field|
  select(value, from: field)
end

Pak(/^změním "(.*?)" na "(.*?)"$/) do |old_value, new_value|
  find("input[value=\"#{old_value}\"]").set(new_value)
end

Když(/^zadám další adresu "(.*?)"$/) do |adr|
  fill_in('Vaše další emailová adresa', with: adr)
end

Pokud(/^otevřu si formulář pro přidání$/) do
  click_button('Přidat')
end
