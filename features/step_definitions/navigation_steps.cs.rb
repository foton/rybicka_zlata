# frozen_string_literal: true

Given(/^jsem na (.*)$/) do |kde|
  new_path = path_to(kde)
  visit new_path unless current_path == new_path
end

Given(/^jdu na (.*)$/) do |kde|
  visit path_to(kde)
end
