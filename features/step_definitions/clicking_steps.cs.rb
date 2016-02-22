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
  click_link_or_button("add")
end

Když(/^kliknu na pokračování$/) do
  click_link_or_button("forward")
end

Když(/^kliknu na uložení$/) do
  click_link_or_button("check")
end

Když(/^kliknu na editaci$/) do
  click_link_or_button("mode_edit")
end

Pokud(/^kliknu na (editaci|smazání) u "(.*?)"$/) do |action, text_to_find|
  case action
	  when "smazání"
	  	button_hidden_text="remove"
	  when "editaci"
	  	button_hidden_text="mode_edit"
  end
  
  element=find("li", text: text_to_find)
  
  within(element) do
    click_link_or_button(button_hidden_text)	
  end  
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

Pokud(/^do seznamu dárců přidám "(.*?)"$/) do |label|
  within("#donors_connections") do
    check label 
  end
end


