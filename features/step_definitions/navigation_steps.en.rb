# frozen_string_literal: true

Given(/^I am on (.*)$/) do |kde|
  visit path_to(kde)
end
