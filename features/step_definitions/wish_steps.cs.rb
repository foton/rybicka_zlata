# frozen_string_literal: true

Pak(/^můžu rovnou přidat další přání$/) do
  # find(".new", text: "Přidat další přání").click()
  find('.new').click
  # should take me to New wish
  find('#new_wish')
end

Pokud("{string} změní přání {string}") do |user_name, wish_title|
  @wish = Wish.find_by(title: wish_title)
  @wish.description += ' and others'
  @wish.save!
end

