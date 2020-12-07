# frozen_string_literal: true

require 'nokogiri'

Pak(/^(?:bych měl|měl bych) vidět (?:(?:text|přání) )?"([^"]*)"$/) do |text|
  page.find('body', text: text)
end

Pak(/^vidím (?:text )?"([^"]*)"$/) do |text|
  step "měl bych vidět \"#{text}\""
end

Pak(/^(?:bych neměl|neměl bych) vidět (?:(?:text|přání) )?"([^"]*)"$/) do |text|
  assert_no_text(text)
end

Pak(/^(?:bych neměl|neměl bych) vidět (?:text )?"([^"]*)" v nadpisech$/) do |text|
  doc = Nokogiri::HTML.parse(page.html)

  %w[h1 h2 h3 h4 h5 h6].each do |h_type|
    headers = doc.css(h_type).select { |h| h.text.include?(text) }
    assert_no_text(text, "There is text '#{text}' in #{h_type} headers") unless headers.empty?
  end
end

Pak(/^bych měl vidět nadpis "([^"]*)"$/) do |text|
  founded = false
  %w[h6 h1 h2 h3 h4 h5 h6].each do |h_type|
    begin
      find(h_type, text: text)
      founded = true
    rescue Capybara::ElementNotFound
      # just leave it for next item
    end
    break if founded
  end
  raise Capybara::ElementNotFound unless founded
end

Pak(/^měl bych vidět popis "([^"]*)"$/) do |text|
  find('#description', text: text)
end

Pak(/^měl bych vidět spoluobdarované \[(.*?)\]$/) do |donee_names_str|
  donee_names = donee_names_str.delete('"').split(',').collect(&:strip)

  within(:css, '#donees_list') do
    donee_names.each do |donee_name|
      find('li', text: donee_name)
    end
  end
end

Pak(/^v seznamu (?:lidí|přátel) (je|není) kontakt "(.*?)" s adresou "(.*?)"$/) do |je_neni, name, email|
  within(:css, '#connections_list') do
    # find('li', text: Regexp.new("\A#{name} \[.*\]: #{email}\z") )
    if je_neni == 'je'
      find('li', text: Regexp.new("#{name} .* #{email}"))
    else
      assert_no_text(email)
    end
  end
end

Pak(/^v seznamu skupin je skupina "(.*?)" se? (\d+) členy$/) do |name, _count|
  within(:css, '#groups_list') do
    find('li', text: name) #+"[#{count}]")
  end
end

Pak(/^v seznamu skupin není skupina "(.*?)"$/) do |name|
  within(:css, '#groups_list') do
    assert_no_text(name)
  end
end

Pak(/^vidím kontakt "([^"]*)"$/) do |name|
  find('li', text: name)
end

Pak(/^nevidím kontakt "([^"]*)"$/) do |name|
  assert_no_text(name)
end

Pak(/^vidím kontakt "([^"]*)" v "([^"]*)"$/) do |name, block_name|
  within(:css, block_selector_for(block_name)) do
    find('li', text: name)
  end
end

Pak(/^nevidím kontakt "([^"]*)" v "([^"]*)"$/) do |name, block_name|
  within(:css, block_selector_for(block_name)) do
    assert_no_text(name)
  end
end

Pak(/^vidím lidi ze skupiny "([^"]*)" v "([^"]*)"$/) do |grp_name, block_name|
  grp = Group.where(user: @current_user).find_by(name: grp_name)
  grp.connections.each do |conn|
    step "vidím kontakt \"#{conn.name}\" v \"#{block_name}\""
  end
end

Pak(/^je v seznamu mých e-mailových adres vidět i "(.*?)"$/) do |adr|
  within(:css, '#contacts_list') do
    find('li', text: adr)
  end
end

Pak(/^v seznamu kontaktů už není adresa "(.*?)"$/) do |adr|
  within(:css, '#contacts_list') do
    assert_no_text(adr)
  end
end

Pokud(/^v seznamu přání (?:u "(.*?)" )?je přání "(.*?)"(?: se (\d+) potenciálními dárci)?$/) do |user_name, wish_title, _donor_count|
  visit 'přání uživatele "user_name"' if user_name.present?

  within(:css, '.wishes-list') do
    #  if donor_count.present?
    #    find('li', text: wish_title+"[#{donor_count}]")
    #  else
    find('li', text: wish_title)
    #  end
  end
end

Pak(/^v seznamu přání není přání "(.*?)"$/) do |wish_title|
  within(:css, '.wishes-list') do
    assert_no_text(wish_title)
  end
end

Pokud(/^u přání "(.*?)" jsou akce \[(.*?)\]$/) do |wish_title, actions_str|
  action_names = actions_str.delete('"').split(',').collect { |name| name.strip.mb_chars.upcase }

  within(:css, '#wishes') do
    wish = find('li', text: wish_title)
    action_names.each do |action_name|
      wish.find('.actions').find('a', text: action_name)
    end
  end
end

Pak(/^u přání "([^"]*)" nejsou žádné akce$/) do |wish_title|
  within(:css, '#wishes') do
    actions = find('li', text: wish_title).find('.actions')
    assert(actions.text == '')
  end
end

Pak('bych neměl vidět žádnou notifikaci k přání {string}') do |wish_title|
  assert_no_text(wish_title)
end

Pak('bych měl vidět notifikaci {string}') do |change_text|
  assert_text(change_text)
end

def block_selector_for(block_name)
  case block_name
  when 'Dárci'
    '#donor_connections'
  when 'Obdarovaní'
    '#donee_connections'
  else
    raise "Uncatched block_name: '#{block_name}'"
  end
end
