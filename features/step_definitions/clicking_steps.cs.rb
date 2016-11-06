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
  find(".new").click()
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

Pokud(/^kliknu na (editaci|smazání|rezervaci|uvolnění rezervace|darování|výzvu ke spoluúčasti|uvolnění výzvy|splnění) u(?: přání)? "(.*?)"$/) do |action, text_to_find|
  case action
	  when "smazání"
	  	a_selector=".delete"
	  when "editaci"
	  	a_selector=".edit"
    when "rezervaci"
      a_selector=".book"
    when "uvolnění rezervace"
      a_selector=".unbook"
    when "darování"
      a_selector=".gifted"
    when "výzvu ke spoluúčasti"
      a_selector=".call_for_co_donors"
    when "uvolnění výzvy"
      a_selector=".withdraw_call"
    when "splnění"  
      a_selector=".fulfilled"
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
  #uncheck label  #does not work, because checkbox itself is not visible. Only modified label.
  
  if has_field?(label, checked: true)
    begin
      uncheck label    
    rescue  #Capybara::Webkit::ClickFailed
      find("label", text: label).click()
    end  
  else
    raise Capybara::ElementNotFound.new("Checked field with label/id '#{label}' was not found")
  end  
end

Pak(/^(?:do seznamu )?přidám "(.*?)"$/) do |label|
  #find checkbox and if unchecked, check it
  
  if has_field?(label, checked: false)
    begin
      check label
    rescue  
      find("label", text: label).click()
    end  
  else
    raise Capybara::ElementNotFound.new("Unchecked field with label/id '#{label}' was not found")
  end  
end

Když(/^kliknu v menu na "(.*?)"$/) do |text|
  within("div#main_menu") do
    begin
      click_link_or_button(text)  
    rescue Capybara::Webkit::ClickFailed => e
      js_click_link(text)
    end  
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

Pak(/^pokud si otevřu přání "([^"]*)"$/) do |wish_title|
  click_link(wish_title)
end

Pak(/^pokud si otevřu přání "([^"]*)" u "([^"]*)"$/) do |wish_title, user_name|
  header_with_name=find("h4", text: user_name)
  #method .parent returns whole document ?!
  donee_block = header_with_name.find(:xpath, '..')
  donee_block.click_link(wish_title)
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
