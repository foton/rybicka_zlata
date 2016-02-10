#encoding: utf-8

Then /^(?:bych měl|měl bych) vidět (?:text )?"([^"]*)"$/ do |text|
  page.find('body', text: text)
end

Pak(/^vidím (?:text )?"([^"]*)"$/) do |text|
  step "měl bych vidět \"#{text}\""
end

Pak(/^v seznamu (?:lidí|přátel) (je|není) kontakt "(.*?)" s adresou "(.*?)"$/) do |je_neni, name, email|
  within(:css, "#connections_list") do
    #find('li', text: Regexp.new("\A#{name} \[.*\]: #{email}\z") )
    if je_neni=="je"
      find('li', text: Regexp.new("#{name} .* #{email}") )
    else
      assert_no_text(email)
    end  
  end  
end

Pak(/^v seznamu skupin je skupina "(.*?)" se? (\d+) členy$/) do |name, count|
  within(:css, "#groups_list") do
    find('li', text: name+"[#{count}]")
  end  
end

Pak(/^v seznamu skupin není skupina "(.*?)"$/) do |name|
  within(:css, "#groups_list") do
    assert_no_text(name)
  end  
end

Pak(/^vidím konexi "([^"]*)"$/) do |name|
  find('li', text: name)
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


