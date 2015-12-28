#encoding: utf-8

When /^(?:vyplním|zapíšu) do (?:položky )?"([^"]*)" text "([^"]*)"$/ do |polozka, text|
  fill_in(polozka, :with => text)
end

When /^vyberu "([^"]*)" z nabídky "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end
