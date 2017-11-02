# frozen_string_literal: true

Given /^(?:bych měl|měl bych) být úspěšně přihlášen$/ do
  step 'měl bych vidět text "Přihlášení bylo úspěšné."'
  within('.mdl-layout__drawer nav') do
    assert page.has_link?('Odhlásit')
  end
end

Pak(/^bych se měl bez problémů přihlásit jako "(.*?)" s heslem "(.*?)"$/) do |email, password|
  step 'kliknu v menu na "Odhlásit"' if page.has_link?('Odhlásit')
  step "přihlásím se jako \"#{email}\" s heslem \"#{password}\""
  step 'měl bych být úspěšně přihlášen'
end

Pak(/^přihlásím se jako "(.*?)" s heslem "(.*?)"$/) do |email, password|
  visit path_to('přihlášení')
  step "zapíšu do položky \"Hlavní e-mail\" text \"#{email}\""
  step "zapíšu do položky \"Heslo\" text \"#{password}\""
  step 'kliknu na tlačítko "Přihlásit"'
  step 'měl bych být úspěšně přihlášen'
  @current_user = @users.find { |u| u.email == email } if @users.present?
end

Pokud(/^jsem přihlášen jako "(.*?)"$/) do |name|
  current_user = @users.find { |u| u.name == name }
  step "přihlásím se jako \"#{current_user.email}\" s heslem \"#{DEFAULTS[:password]}\""
end

Given /^(?:odhlásím se|se odhlásím)$/ do
  step 'kliknu v menu na "Odhlásit"' if page.has_link?('Odhlásit')
  @current_user = nil
end
