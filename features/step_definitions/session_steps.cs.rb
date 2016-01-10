#encoding: utf-8

Given /^(?:bych měl|měl bych) být úspěšně přihlášen$/ do
  step "měl bych vidět text \"Přihlášení úspěšné.\""
  within(".mdl-layout__drawer nav") do
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
  @current_user=@users.find {|u| u.email == email}
end


Pokud(/^jsem přihlášen jako "(.*?)"$/) do |name|
  current_user=@users.find {|u| u.name == name}
  step "přihlásím se jako \"#{current_user.email}\" s heslem \"#{DEFAULTS[:password]}\""
end

Given /(?:odhlásím se|se odhlásím)/ do
  visit logout_path
  @current_user=nil
end

