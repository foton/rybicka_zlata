#encoding: utf-8

Then /^(?:bych měl|měl bych) vidět (?:text )?"([^"]*)"$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath('//*', :text => regexp)
  else
    assert page.has_xpath?('//*', :text => regexp)
  end
end

Pak(/^vidím (?:text )?"([^"]*)"$/) do |text|
  step "měl bych vidět \"#{text}\""
end

Pak(/^v seznamu lidí je "(.*?)" s adresou "(.*?)"$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Pak(/^v seznamu lidí (je|není) kontakt "(.*?)"$/) do |je_neni, kontakt|
  pending # express the regexp above with the code you wish you had
end

Pak(/^v seznamu skupin je "(.*?)" se členy \["(.*?)","(.*?)"\]$/) do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Pak(/^v seznamu skupin není skupina "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Pak(/^v seznamu skupin je skupina "(.*?)" se členy \["(.*?)", "(.*?)","(.*?)"\]$/) do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
end

Pak(/^je v seznamu mých e\-mailových adres vidět i "(.*?)"$/) do |adr|
  within(:css, "#contacts_list") do
    find('li', text: adr)
  end  
end

Pak(/^v seznamu kontaktů už není adresa "(.*?)"$/) do |adr|
  within(:css, "#contacts_list") do
    assert_no_text(adr)
  end  
end


