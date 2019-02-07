# frozen_string_literal: true

Pokud(/^existují tito uživatelé:$/) do |table|
  @users = User.all.to_a

  table.hashes.each do |attributes|
    admin = attributes.delete('admin') == 'true'
    unconfirmed = attributes.delete('unconfirmedin') == 'true'

    @user = User.where(email: attributes[:email]).first
    if @user.blank?
      @user = User.create(attributes)
      #    @user.admin=admin
      @user.confirm unless unconfirmed
      unless @user.save
        raise "User not created! Errors :#{@user.errors.full_messages} for user: #{@user}}"
      end
    end

    @users << @user
  end
  @users.uniq!
end

Pokud(/^existují standardní testovací uživatelé$/) do
  @users = User.all.to_a
  # see test/fixtures/fixture_consistency_test.rb  for users, identities, wishes and other fixtures
end

Pokud(/^existuje (?:přítel|přátelství) "(.*?)"$/) do |connection_fullname|
  unless (m = connection_fullname.strip.match(/\A(.*) \[(.*)\]: (.*)\z/))
    raise "Unable to parse connection from fullname '#{connection_fullname}'"
  end

  @friend_connection = check_connection(@current_user, name: m[1], email: m[3])
  User.create!(name: m[2], email: m[3], password: 'password')
  @friend_connection.reload
end

Pokud(/^přidám přítele "(.*?)"$/) do |connection_fullname|
  unless (m = connection_fullname.strip.match(/\A(.*) \[(.*)\]: (.*)\z/))
    raise "Unable to parse connection from fullname '#{connection_fullname}'"
  end

  conn_name = m[1]
  user_name = m[2]
  email = m[3]

  User.create!(name: user_name, email: email, password: 'password')

  @friend_connection = Connection.new(name: m[1], email: m[3])
  @current_user.connections << @friend_connection
end

Pokud('ten má v oblibě {string}') do |likes_what|
  raise 'Missing @friend_connection' unless @friend_connection

  u = @friend_connection.friend
  u.likes = likes_what
  u.save!
end

Pokud(/^existuje kontakt "(.*?)"$/) do |connection_name|
  check_connection(@current_user, name: connection_name)
end

Pokud(/^(?:u "(.*?)" )?existuje skupina "(.*?)" se členy \[([^\]]*)\]$/) do |user_name, grp_name, grp_members_to_s|
  if user_name.present?
    user = User.find_by(emailname: formalize_user_name(user_name))
    raise "User with name '#{user_name}' not found" if user.blank?
  else
    user = @current_user
  end

  grp = user.groups.find_by(name: grp_name)
  grp = user.groups.create!(name: grp_name) if grp.blank?

  members = []
  grp_members_to_s.split(',').each do |mem_name|
    mem_name = mem_name.delete('"').strip
    conn = user.connections.find_by(name: mem_name)
    conn = user.connections.create!(name: mem_name, email: "#{mem_name}@rybickazlata.cz") if conn.blank?
    members << conn
  end
  grp.connections = members
  grp.save!
end

Pokud(/^"(.*?)" má kontakt "(.*?)"$/) do |user_name, email_adr|
  user = User.find_by(name: user_name)
  id = user.identities.where(email: email_adr).first
  if id.blank?
    User::Identity.create!(email: email_adr, provider: User::Identity::LOCAL_PROVIDER, user_id: user.id)
  end
end

Pokud(/^mám mezi kontakty adresu "(.*?)"$/) do |adr|
  step "\"#{@current_user.name}\" má kontakt \"#{adr}\""
end

Pokud(/^zaloguju text "(.*?)"$/) do |text|
  logger.info(text)
end

Pokud(/^u "(.*?)" existuje kontakt "(.*?)"(?: s adresou "(.*?)")?$/) do |user_name, conn_name, conn_email|
  user = find_user_by(user_name)
  raise "User with name '#{user_name}' not found" if user.blank?

  check_connection(user, name: conn_name, email: conn_email)
end

Pokud(/^existuje moje přání "(.*?)"$/) do |title|
  raise 'do not use'
  @wish = Wish::FromAuthor.new(author: @current_user, title: title, description: "Description of přání #{title}")
  @wish.save!
end

Pokud(/^přidám přání "(.*?)" uživatele "(.*?)" pro dárce \{(.*?)\}$/) do |title, user_name, donee_donors_hash_str|
  user = find_user_by(user_name)
  @wish = Wish::FromAuthor.new(author: user, title: title, description: "Description of přání #{title}")

  donee_donors_pairs = donee_donors_hash_str.scan(/"([[:word:]]+)"\s*=>\s*\[([^\]]+)\]/)
  assert donee_donors_pairs.present?

  donee_donors_pairs.each do |donee_name, connection_names_csv|
    donee = find_user_by(donee_name)
    conn_names = connection_names_csv.delete('"').split(',').collect(&:strip)
    named_donee_connection_ids = donee.connections.where(name: conn_names).pluck(:id)

    @wish.merge_donor_conn_ids(named_donee_connection_ids, donee)
  end

  @wish.save!
end

Pokud(/^existuje přání "(.*?)" uživatele "(.*?)"$/) do |title, user_name|
  user = find_user_by(user_name)
  @wish = user.author_wishes.find_by(title: title)
  raise "Wish '#{title}' with '#{user_name}' as author was not found" unless @wish
end

Pokud(/^to má dárce \{(.*?)\}$/) do |donee_donors_hash_str|
  expected_donee_donors_pairs = donee_donors_hash_str.scan(/"([[:word:]]+)"\s*=>\s*\[([^\]]+)\]/)
  assert expected_donee_donors_pairs.present?

  expected_donee_donors_pairs.each do |donee_name, connection_names_csv|
    donee = find_user_by(donee_name)
    conn_names = connection_names_csv.delete('"').split(',').collect(&:strip)
    named_donee_connection_ids = donee.connections.where(name: conn_names).pluck(:id)
    assert_equal named_donee_connection_ids, (@wish.donor_connections.pluck(:id) & named_donee_connection_ids)
  end
end

Pokud(/^má v obdarovaných \[(.*?)\]$/) do |donee_names_str|
  expected_donee_names = donee_names_str.delete('"').split(',').collect(&:strip)
  assert expected_donee_names, (@wish.donee_users.pluck(:name) & expected_donee_names)
end

def check_connection(user, conn_hash)
  conns = user.connections.where(name: conn_hash[:name])
  if conn_hash[:email].present?
    conns = conns.select { |conn| conn.email == conn_hash[:email] } if conns.present?
  end
  assert_equal 1, conns.size
  conns.first
end
