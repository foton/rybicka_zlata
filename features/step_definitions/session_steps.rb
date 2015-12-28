#encoding: utf-8

Given /^(?:bych měl|měl bych) být úspěšně přihlášen jako "([^"]*)"$/ do |displayed_name|
  within("#session") do
    assert page.has_link?(displayed_name)
  end
end

