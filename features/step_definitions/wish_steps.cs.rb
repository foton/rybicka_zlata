# frozen_string_literal: true

Pak(/^můžu rovnou přidat další přání$/) do
  # find(".new", text: "Přidat další přání").click()
  find('.new').click
  # should take me to New wish
  find('#new_wish')
end

Pokud("{string} změní přání {string}") do |user_name, wish_title|
  @wish = Wish.find_by(title: wish_title)
  user = find_user_by(user_name)
  assert user.present?
  wu = WishUpdater.call(@wish, { description: @wish.description + ' and others' }, user)
  assert wu.success?
  @wish = wu.result.wish
end

