# frozen_string_literal: true

When(/^fill in text "([^"]*)" into "([^"]*)"(?: input)?$/) do |text, polozka|
  replace_field_value(find_field(polozka), text)
end

When(/^select "([^"]*)" from "([^"]*)" selection$/) do |value, field|
  select(value, from: field)
end
