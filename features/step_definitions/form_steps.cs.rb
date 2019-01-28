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

Pokud(/^doplním podrobnější info do položky "Další míry"$/) do
  text = 'Obvod hlavy: 60; Dolní obvod krku: 85cm; Obvod hrudníku přes prsa 185cm; ' \
         'Podprsenky - obvod pod prsy 165cm; ' \
         'Obvod v pase přes pupík 165cm; ' \
         'Obvod v bocích přes zadek 165cm; ' \
         'Délka mezi rameními švy zadem za krkem 165cm; '\
         'Délka rukávu od ramenního švu po zápěstí 165cm; ' \
         'Délka košile/trička vzadu od krku dolů 165cm; ' \
         'Vnější délka nohavice od boku do konci nohavice 165cm; ' \
         'Délka vnitřního švu nohavice (od rozkroku ke konci nohavice) 165cm; ' \
         'Délka chodidla od paty po palec 165cm'
  fill_in('Další míry', with: text)
end