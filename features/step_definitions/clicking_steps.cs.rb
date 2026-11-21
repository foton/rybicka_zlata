# frozen_string_literal: true

When(/^kliknu na "([^"]*)"$/) do |co|
  click_link_or_button(co)
end

When(/^kliknu na odkaz "([^"]*)"$/) do |co|
  click_link(co)
end

When(/^kliknu na tlačítko "([^"]*)"$/) do |co|
  click_button(co)
end

When(/^přepnu na češtinu$/) do
  visit '/change_locale?locale=cs'
end

Když(/^kliknu na přidání$/) do
  # click_link_or_button("add")
  find('.new').click
end

Když(/^kliknu na pokračování$/) do
  # click_link_or_button("forward")
  find('.next-step').click
end

Když(/^kliknu na uložení$/) do
  # click_link_or_button("check")
  find('.save').click
end

Když(/^kliknu na editaci$/) do
  find('.edit').click
end

Pokud(/^kliknu na (editaci|smazání|rezervaci|uvolnění rezervace|darování|výzvu ke spoluúčasti|uvolnění výzvy|splnění) u(?: přání)? "(.*?)"$/) do |action, text_to_find|
  case action
  when 'smazání'
    a_selector = '.delete'
  when 'editaci'
    a_selector = '.edit'
  when 'rezervaci'
    a_selector = '.book'
  when 'uvolnění rezervace'
    a_selector = '.unbook'
  when 'darování'
    a_selector = '.gifted'
  when 'výzvu ke spoluúčasti'
    a_selector = '.call_for_co_donors'
  when 'uvolnění výzvy'
    a_selector = '.withdraw_call'
  when 'splnění'
    a_selector = '.fulfilled'
  end

  find('li', text: text_to_find).find(a_selector).click
end

Když(/^smazání potvrdím$/) do
  within('#confirm-dialog') do
    click_button('Ano')
  end
end

Pak(/^(?:ze seznamu )?vyřadím "(.*?)"$/) do |label|
  # find checkbox and if checked, uncheck it
  # uncheck label  #does not work, because checkbox itself is not visible. Only modified label.

  unless has_field?(label, checked: true, visible: :all)
    raise Capybara::ElementNotFound, "Checked field with label/id '#{label}' was not found"
  end

  begin
    uncheck label
  rescue StandardError # Capybara::Webkit::ClickFailed
    find('label', text: label).click
  end
end

Pak(/^(?:do seznamu )?přidám "(.*?)"$/) do |label|
  # find checkbox and if unchecked, check it

  unless has_field?(label, checked: false, visible: :all)
    raise Capybara::ElementNotFound, "Unchecked field with label/id '#{label}' was not found"
  end

  begin
    check label
  rescue StandardError
    find('label', text: label).click
  end
end

Když(/^kliknu v menu na "(.*?)"$/) do |text|
  within('#main_menu') do
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

# ConnectionPickerComponent: a contact (or group) row has either a segmented button
# Obdarovaný | — | Dárce (author's wish form) or a checkbox (co-donee's donors).
Pokud(/^do seznamu (dárců|obdarovaných) přidám "(.*?)"$/) do |block, label|
  set_connection_role(label, block == 'dárců' ? :donor : :donee)
end

Pak(/^ze seznamu (?:dárců|obdarovaných) odeberu "(.*?)"$/) do |label|
  set_connection_role(label, :none)
end

# row of a contact / group; group rows start with the icon ligature "groups"
def picker_row(label)
  find('.rz-picker__row', text: /\A\s*(?:groups\s+)?#{Regexp.escape(label)}/)
end

def set_connection_role(label, role)
  within('#user_connections') do
    row = picker_row(label)
    if row.has_css?('.rz-segmented', wait: 0)
      row.find(".rz-segmented__segment--#{role}").click
    else
      checkbox = row.find('input[type="checkbox"]', visible: :all)
      checkbox.click if checkbox.checked? == (role == :none)
    end
  end
end

Pak(/^pokud si otevřu přání "([^"]*)"$/) do |wish_title|
  click_link(wish_title)
end

Pak(/^pokud si otevřu přání "([^"]*)" u "([^"]*)"$/) do |wish_title, user_name|
  header_with_name = find('h4', text: user_name)
  # method .parent returns whole document ?!
  donee_block = header_with_name.find(:xpath, '..')
  donee_block.click_link(wish_title)
end

