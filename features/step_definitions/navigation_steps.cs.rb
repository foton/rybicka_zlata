# frozen_string_literal: true

Given(/^jsem na (.*)$/) do |kde|
  new_path = path_to(kde)
  # after a form submit the browser may still be on its way (redirect) to new_path:
  # visiting it again would drop the flash message of that redirect
  visit new_path unless page.has_current_path?(new_path, ignore_query: true, wait: 2)
end

Given(/^jdu na (.*)$/) do |kde|
  visit path_to(kde)
end

Pokud('já si otevřu stránku {string}') do |string|
  visit path_to(string)
end
