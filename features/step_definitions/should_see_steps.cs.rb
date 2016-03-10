#encoding: utf-8

require 'nokogiri'

Pak /^(?:bych měl|měl bych) vidět (?:(?:text|přání) )?"([^"]*)"$/ do |text|
  page.find('body', text: text)
end

Pak(/^vidím (?:text )?"([^"]*)"$/) do |text|
  step "měl bych vidět \"#{text}\""
end

Pak /^(?:bych neměl|neměl bych) vidět (?:(?:text|přání) )?"([^"]*)"$/ do |text|
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

Pak(/^bych měl vidět nadpis "([^"]*)"$/) do |text|
  founded=false
  for h_type in ["h6","h1","h2","h3","h4","h5","h6"] do
    begin
      find(h_type, text: text)
      founded=true
    rescue Capybara::ElementNotFound  
      #just leave it for next item
    end
    break if founded
  end
  raise Capybara::ElementNotFound  unless founded
end

Pak(/^měl bych vidět popis "([^"]*)"$/) do |text|
  find("#description", text: text)
end

Pak(/^měl bych vidět spoluobdarované \[(.*?)\]$/) do |donee_names_str|
  donee_names=donee_names_str.gsub("\"","").split(",").collect {|name| name.strip}
  
  within(:css, "#donees_list") do
     for donee_name in donee_names
        find("li", text: donee_name)
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

Pak(/^vidím konexi "([^"]*)" v "([^"]*)"$/) do |name, block_name|
  within(:css, block_selector_for(block_name)) do
    find('li', text: name)
  end
end

Pak(/^nevidím konexi "([^"]*)" v "([^"]*)"$/) do |name, block_name|
  within(:css, block_selector_for(block_name)) do
    assert_no_text(name)
  end
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


Pokud(/^v seznamu přání (?:u "(.*?)" )?je přání "(.*?)"(?: se (\d+) potenciálními dárci)?$/) do |user_name, wish_title, donor_count|
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

Pak(/^v seznamu přání není přání "(.*?)"$/) do |wish_title|
  within(:css, ".wishes-list") do
    assert_no_text(wish_title)
  end  
end

Pokud(/^u přání "(.*?)" jsou akce \[(.*?)\]$/) do |wish_title, actions_str|
  action_names=actions_str.gsub("\"","").split(",").collect {|name| name.strip.mb_chars.upcase}
  
   within(:css, "#wishes") do
    wish=find('li', text: wish_title)
    for action_name in action_names
      wish.find(".actions").find("a", text: action_name)
    end
  end  
  
end

Pak(/^u přání "([^"]*)" nejsou žádné akce$/) do |wish_title|
   within(:css, "#wishes") do
    actions=find('li', text: wish_title).find(".actions")
    assert(actions.text == "")
  end  
  
end



def block_selector_for(block_name)
   case block_name
    when "Dárci" 
      return "#donor_connections"
    when "Obdarovaní"  
      return "#donee_connections"
    else
      raise "Uncatched block_name: '#{block_name}'"
   end 
end
