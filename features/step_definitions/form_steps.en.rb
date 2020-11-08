# frozen_string_literal: true

When(/^fill in text "([^"]*)" into "([^"]*)"(?: input)?$/) do |text, polozka|
  fill_in(polozka, with: text)
end

When(/^select "([^"]*)" from "([^"]*)" selection$/) do |value, field|
  select(value, from: field)
end
