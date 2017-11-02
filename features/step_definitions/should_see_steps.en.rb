# frozen_string_literal: true

Then /^(?:I )?should see (?:text )?"([^"]*)"$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath('//*', text: regexp)
  else
    assert page.has_xpath?('//*', text: regexp)
  end
end

When(/^show me the page$/) do
  save_and_open_page
end
