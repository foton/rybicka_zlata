# frozen_string_literal: true

Pokud /^existují tito uživatelé\:$/ do |table|
  @users = []

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
end

Pokud /^existují standardní testovací uživatelé$/ do
  step('existují tito uživatelé:', table(%(
        | name        | email                   | locale  | password                |  admin  |
        | porybny     |porybny@rybickazlata.cz  | cs      | #{DEFAULTS[:password]}  |  true   |
        | charles     |charles@rybickazlata.cz  | en      | #{DEFAULTS[:password]}  |  false  |
        | pepik       |pepik@rybickazlata.cz    | cs      | #{DEFAULTS[:password]}  |  false  |
        | Mařenka     |marenka@rybickazlata.cz  | cs      | #{DEFAULTS[:password]}  |  false  |
        | Karel       |karel@rybickazlata.cz    | cs      | #{DEFAULTS[:password]}  |  false  |
        | Mojmír      |mojmir@rybickazlata.cz   | cs      | #{DEFAULTS[:password]}  |  false  |
        )))
end

Pokud(/^existuje (?:přítel|přátelství) "(.*?)"$/) do |connection_fullname|
  if m = connection_fullname.strip.match(/\A(.*) \[.*\]: (.*)\z/)
    make_connection_for(@current_user, name: m[1], email: m[2])
  else
    raise "Unable to parse connection from fullname '#{connection_fullname}'"
  end
end

Pokud(/^existuje kontakt "(.*?)"$/) do |connection_name|
  make_connection_for(@current_user, name: connection_name)
end

# Pokud(/^existuje skupina "(.*?)" se členy \[([^\]]*)\]$/) do |grp_name, grp_members_to_s|
#   grp=@current_user.groups.find_by_name(grp_name)
#   if grp.blank?
#     grp=@current_user.groups.create!( name: grp_name)
#   end

#   members=[]
#   for mem_name in grp_members_to_s.split(",")
#     mem_name=mem_name.gsub("\"","").strip
#     conn=@current_user.connections.find_by_name(mem_name)
#     conn=@current_user.connections.create!(name: mem_name, email: "#{mem_name}@example.com") if conn.blank?
#     members << conn
#   end
#   grp.connections = members
#   grp.save!
# end

Pokud(/^(?:u "(.*?)" )?existuje skupina "(.*?)" se členy \[([^\]]*)\]$/) do |user_name, grp_name, grp_members_to_s|
  if user_name.present?
    user = User.find_by(name: formalize_user_name(user_name))
    raise "User with name '#{user_name}' not found" if user.blank?
  else
    user = @current_user
  end

  grp = user.groups.find_by(name: grp_name)
  grp = user.groups.create!(name: grp_name) if grp.blank?

  members = []
  for mem_name in grp_members_to_s.split(',')
    mem_name = mem_name.delete('"').strip
    conn = user.connections.find_by(name: mem_name)
    conn = user.connections.create!(name: mem_name, email: "#{mem_name}@example.com") if conn.blank?
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
  user = User.find_by(name: formalize_user_name(user_name))
  raise "User with name '#{user_name}' not found" if user.blank?

  make_connection_for(user, name: conn_name, email: conn_email)
end

Pokud(/^existuje moje přání "(.*?)"$/) do |title|
  @wish = Wish::FromAuthor.new(author: @current_user, title: title, description: "Description of přání #{title}")
  @wish.save!
end

Pokud(/^existuje přání "(.*?)" uživatele "(.*?)"$/) do |title, user_name|
  user = User.find_by(name: user_name)
  @wish = Wish::FromAuthor.new(author: user, title: title, description: "Description of přání #{title}")
  @wish.save!
end

Pokud(/^to má dárce \[(.*?)\]$/) do |donor_names_str|
  donor_names = donor_names_str.delete('"').split(',').collect(&:strip)
  donor_conn_ids = []

  for donor_name in donor_names do
    donor_conn_ids << make_connection_for(@wish.author, name: donor_name).id
  end

  if donor_conn_ids.present?
    @wish.merge_donor_conn_ids(donor_conn_ids, @wish.author)
    @wish.save!
  end
end

Pokud(/^má v obdarovaných \[(.*?)\]$/) do |donee_names_str|
  donee_names = donee_names_str.delete('"').split(',').collect(&:strip)
  donee_conn_ids = []

  for donee_name in donee_names do
    donee_conn_ids << make_connection_for(@wish.author, name: donee_name).id
  end

  if donee_conn_ids.present?
    @wish.donee_conn_ids = donee_conn_ids
    @wish.save!
  end
end

#===============================================

def make_connection_for(user, conn_hash)
  conns = user.connections.where(name: conn_hash[:name])
  if conn_hash[:email].present?
    conns = conns.select { |_conn| con.email == conn_hash[:email] } if conns.present?
  else
    conn_hash[:email] = "#{conn_hash[:name].parameterize}@example.com"
  end

  if conns.blank?
    # lets create it
    conn = Connection.new(name: conn_hash[:name], email: conn_hash[:email])
    user.connections << conn
    user.connections.reload
  elsif conns.size != 1
    raise "Ambiguous match for '#{conn_hash}' for user '#{user.username}': #{conns.join("\n")}"
  else
    conn = conns.first
  end
  conn
end

def formalize_user_name(user_name)
  case user_name
  when 'pepika', 'Pepika'
    'pepik'
  when 'Mařenky'
    'Mařenka'
  else
    user_name
  end
end
