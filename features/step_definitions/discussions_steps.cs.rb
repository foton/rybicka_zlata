Pak('bych měl vidět formulář na první příspěvek') do
  find('#post_form form')
end

Pak /^(?:měl bych|bych měl) vidět příspěvek "([^"]+)" od "([^"]+)"$/ do |obsah, username|
  post = find('#posts li', text: obsah)
  within post do
    find('div', text: username)
  end
end

Pak('bych neměl vidět příspěvek {string} od {string}') do |obsah, username|
  step("neměl bych vidět text \"#{obsah}\"")
end

Pokud('otevřu si přání {string} u {string}') do |wish_title, username|
  step('jsem na stránce "Můžu splnit"')
  step("pokud si otevřu přání \"#{wish_title}\" u \"#{username}\"")
end

Pokud('přidám příspěvek {string}') do |text|
  fill_in('discussion_post_content', with: text)
  click_button('Přidat příspěvek')
end

Pokud('přidám příspěvek {string} s označením {string}') do |text, flag_text|
  find('label', text: flag_text).click if flag_text == 'Zobrazit i obdarovaným'
  step "přidám příspěvek \"#{text}\""
end

Pokud('se přihlásím jako {string}') do |username|
  step('odhlásím se')
  step("jsem přihlášen jako \"#{username}\"")
end

Pokud('otevřu si svoje přání {string}') do |wish_title|
  step('jsem na stránce "Má přání"')
  click_link wish_title
end

Pokud('někdo z dárců u přání přidá příspěvek pro obdarované') do
  donor = @wish.donor_connections.first.friend
  ds = DiscussionService.new(@wish, donor)
  ds.add_post(content: 'donor non secret post', show_to_anybody: true)
end

Pak('bych neměl mít možnost diskutovat') do
  assert page.has_no_selector?('#post_form form')
  assert_no_text('Přidat příspěvek')
end

Pak('můžu diskutovat') do
  assert page.has_selector?('#post_form form')
  step('měl bych vidět text "Přidat příspěvek"')
end

Pak("můžu smazat příspěvek {string} od {string}") do |comment, username|
  post = find('#posts li', text: comment)
  within post do
    find('div', text: username)
    find('.delete_button').click
    #binding.pry

  #  click_on('Smazat')
  end
  assert_no_text(comment)
end

Pokud("někdo jiný přidá svůj příspěvek") do
  donor = (@wish.donor_connections.detect { |dc| dc.friend != @current_user }).friend
  ds = DiscussionService.new(@wish, donor)
  ds.add_post(content: 'donor other post')
  visit user_others_wish_path(@current_user, @wish, locale: @locale)
end

Pak("už nemůžu smazat příspěvek {string} od {string}") do |comment, username|
  post = find('#posts li', text: comment)
  within post do
    find('div', text: username)
    assert_no_text('delete_forever')
  end
end
