#encoding: utf-8

Given /^(?:bych měl|měl bych) být úspěšně přihlášen jako "([^"]*)"$/ do |displayed_name|
  within("#session") do
    assert page.has_link?(displayed_name)
  end
end

Given /^(?:bych měl|měl bych) být úspěšně přihlášen$/ do
  within("#session") do
    assert page.has_link?(I18n.t("devise.sign_out"))
  end
end

Pak(/^bych se měl bez problémů přihlásit jako "(.*?)" s heslem "(.*?)"$/) do |email, password|
  step "přihlásím se jako \"#{email}\" s heslem \"#{password}\""
  step "měl bych být úspěšně přihlášen"
end

Pak(/^přihlásím se jako "(.*?)" s heslem "(.*?)"$/) do |email, password|
  visit path_to("přihlášení")
  step "zapíšu do položky \"E-mail\" text \"#{email}\""
  step "zapíšu do položky \"Heslo\" text \"#{password}\""
  step "kliknu na \"Přihlásit\""
end

