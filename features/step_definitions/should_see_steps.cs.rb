#encoding: utf-8

require 'nokogiri'

Pak /^(?:bych měl|měl bych) vidět (?:text )?"([^"]*)"$/ do |text|
  page.find('body', text: text)
end

Pak(/^vidím (?:text )?"([^"]*)"$/) do |text|
  step "měl bych vidět \"#{text}\""
end

Pak /^(?:bych neměl|neměl bych) vidět (?:text )?"([^"]*)"$/ do |text|
  assert_no_text(text)
end

Pak /^(?:bych neměl|neměl bych) vidět (?:text )?"([^"]*)" v nadpisech$/ do |text|
  doc = Nokogiri::HTML.parse(page.html)
  
  for h_type in ["h1","h2","h3","h4","h5","h6"] do
    headers=doc.css(h_type).select {|h| h.text.include?(text) }
    if (headers.size != 0)
      assert_no_text(text, "There is text '#{text}' in #{h_type} headers")
    end 
  end
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


Pokud(/^v seznamu přání (?:u "(.*?)" )?je přání "(.*?)"(?: se (\d+) potenciálními dárci)$/) do |user_name, wish_title, donor_count|
  if user_name.present?
    visit "přání uživatele \"user_name\""
  end  
 
  within(:css, ".wishes-list") do
  #  if donor_count.present?
  #    find('li', text: wish_title+"[#{donor_count}]")
  #  else
      find('li', text: wish_title)
  #  end  
  end  
  
end


