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
  pending # express the regexp above with the code you wish you had
end

Pak(/^vyřadím "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Pak(/^přidám "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Pokud(/^do seznamu přidám "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

