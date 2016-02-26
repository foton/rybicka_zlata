#encoding: utf-8

When /^kliknu na "([^"]*)"$/ do |co|
  click_link_or_button(co)
end

When /^kliknu na odkaz "([^"]*)"$/ do |co|
  click_link(co)
end

When /^kliknu na tlačítko "([^"]*)"$/ do |co|
  click_button(co)
end

When(/^přepnu na češtinu$/) do
  visit "/change_locale?locale=cs"  
end

Když(/^kliknu na přidání$/) do
  #click_link_or_button("add")
  find(".create").click()
end

Když(/^kliknu na pokračování$/) do
  #click_link_or_button("forward")
  find(".next-step").click()
end

Když(/^kliknu na uložení$/) do
  #click_link_or_button("check")
  find(".save").click()
end

Když(/^kliknu na editaci$/) do
  find(".edit").click()
end

Pokud(/^kliknu na (editaci|smazání) u(?: přání)? "(.*?)"$/) do |action, text_to_find|
  case action
	  when "smazání"
	  	a_selector=".delete"
	  when "editaci"
	  	a_selector=".edit"
  end
  
  find("li", text: text_to_find).find(a_selector).click()
end

Když(/^smazání potvrdím$/) do
  within("#confirm-dialog") do
    click_button("Ano")
  end  
end

Pak(/^(?:ze seznamu )?vyřadím "(.*?)"$/) do |label|
  #find checkbox and if checked, uncheck it
  uncheck label
end

Pak(/^(?:do seznamu )?přidám "(.*?)"$/) do |label|
  #find checkbox and if unchecked, check it
  check label
end

Když(/^kliknu v menu na "(.*?)"$/) do |text|
  within("div#main_menu") do
    click_link_or_button(text)  
  end  
end

# Pokud(/^kliknu na editaci u přání "(.*?)"$/) do |title|
#   within(:css, "ul") do
#    find("li", text: title).find("a.edit").click()
#   end 
# end

# Pokud(/^kliknu na smazání u přání "(.*?)"$/) do |title|
#   within(:css, "ul") do
#    find("li", text: title).find("a.delete").click()
#   end 
# end


Pokud(/^do seznamu (dárců|obdarovaných) přidám "(.*?)"$/) do |block,label|
  # non dragable version
   # within("#donor_connections") do
   #   check label 
   # end

   within("#user_connections") do
    find("li", text: label).drag_to(find(list_selector_for(block)))
   end 
end

Pak(/^ze seznamu (?:dárců|obdarovaných) odeberu "(.*?)"$/) do |label|
  #it not depend where connections is right now, it shoul be only once on screen
   within("#user_connections") do
    find("li", text: label).drag_to(find("#unused_conn_ids"))
   end 
end

def list_selector_for(block)
   case block
    when "dárců" 
      return "#donor_conn_ids"
    when "obdarovaných"  
      return "#donee_conn_ids"
    else
      raise "Uncatched block: '#{block_name}'"
   end 
end
