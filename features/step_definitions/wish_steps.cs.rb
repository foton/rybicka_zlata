# frozen_string_literal: true

Pak(/^můžu rovnou přidat další přání$/) do
  # find(".new", text: "Přidat další přání").click()
  find('.new').click
  # should take me to New wish
  find('#new_wish')
end

Pokud('{string} změní přání {string}') do |user_name, wish_title|
  load_wish(wish_title)
  load_updating_user(user_name)

  update_wish_with({ description: @wish.description + ' and others' })
end

Pokud('mě {string} odebere z dárců přání {string}') do |user_name, wish_title|
  load_wish(wish_title)
  load_updating_user(user_name)

  conn = connection_for(@current_user, @updating_user)
  new_conn_ids = @wish.donor_conn_ids - [conn.id]

  update_wish_with({ donor_conn_ids: new_conn_ids })
end

Pokud('{string} mě zase přidá do dárců přání {string}') do |user_name, wish_title|
  load_wish(wish_title)
  load_updating_user(user_name)

  conn = connection_for(@current_user, @updating_user)
  new_conn_ids = @wish.donor_conn_ids + [conn.id]

  update_wish_with({ donor_conn_ids: new_conn_ids })
end

Pokud('na mě má {string} kontakt') do |user_name|
  load_updating_user(user_name)

  @friend_connection = Connection.new(name: @current_user.name, email: @current_user.email)
  @updating_user.connections << @friend_connection
end

def load_updating_user(user_name)
  @updating_user = find_user_by(user_name)
  assert @updating_user.present?
end

def load_wish(title)
  @wish = Wish.find_by(title: title)
  assert @wish.present?
end

def update_wish_with(params)
  wu = WishUpdater.call(@wish, params, @updating_user)
  assert wu.success?
  @wish = wu.result.wish
end

def connection_for(friend, user)
  user.connections.where(friend: friend).first
end
