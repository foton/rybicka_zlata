#encoding: utf-8

Given /^I should be successfully signed in$/ do
  step "should see text \"Signed in successfully.\""
  within(".mdl-layout__drawer nav") do
    assert page.has_link?(I18n.t("devise.sessions.destroy.sign_out"))
  end
end

Then(/^I am able to sign in without trouble with email "(.*?)" and password "(.*?)"$/) do |email, password|
  step "sign in as \"#{email}\" with password \"#{password}\""
  step "I should be successfully signed in"
end

Pak(/^sign in as "(.*?)" with password "(.*?)"$/) do |email, password|
  visit path_to("sign_in")
  step "fill in text \"#{email}\" into \"Primary e-mail\" input"
  step "fill in text \"#{password}\" into \"Password\" input"
  step "click on button \"Sign in\""
end

