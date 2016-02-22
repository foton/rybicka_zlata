# encoding: utf-8

Pokud /^existují tito uživatelé\:$/ do |table|
	@users=[]

  table.hashes.each do |attributes|
    admin=attributes.delete("admin") == "true"
    unconfirmed=attributes.delete("unconfirmedin") == "true"
    
    @user = User.create!(attributes)
#    @user.admin=admin
    @user.confirm unless unconfirmed
    @user.save!
    @users << @user
  end
end

Pokud /^existují standardní testovací uživatelé$/ do
  step("existují tito uživatelé:", table(%{
        | name        | email                   | locale  | password  |  admin  |
        | porybny     |porybny@rybickazlata.cz  | cs      | Abcd1234  |  true   |
        | charles     |charles@rybickazlata.cz  | en      | Abcd1234  |  false  |
        | pepik       |pepik@rybickazlata.cz    | cs      | Abcd1234  |  false  |
        | Mařenka     |marenka@rybickazlata.cz  | cs      | Abcd1234  |  false  |
        })
  )
end

Pokud(/^existuje (?:přítel|přátelství) "(.*?)"$/) do |connection_fullname|
  if m=connection_fullname.strip.match(/\A(.*) \[.*\]: (.*)\z/)
    make_connection_for(@current_user,{ name: m[1], email: m[2] })  
  else
     raise "Unable to parse connection from fullname '#{connection_fullname}'"
  end
end

Pokud(/^existuje konexe "(.*?)"$/) do |connection_name|
  make_connection_for(@current_user,{ name: connection_name})  
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
    user=User.find_by_name(formalize_user_name(user_name))
    raise "User with name '#{user_name}' not found" if user.blank?
  else
    user=@current_user
  end  

  grp=user.groups.find_by_name(grp_name)
  if grp.blank?
    grp=user.groups.create!( name: grp_name)
  end  

  members=[]
  for mem_name in grp_members_to_s.split(",")
    mem_name=mem_name.gsub("\"","").strip
    conn=user.connections.find_by_name(mem_name)
    conn=user.connections.create!(name: mem_name, email: "#{mem_name}@example.com") if conn.blank?
    members << conn
  end  
  grp.connections = members
  grp.save!
  
end



Pokud(/^mám mezi kontakty adresu "(.*?)"$/) do |adr|
  id=@current_user.identities.where(email: adr).first
  if id.blank?
    User::Identity.create!(email: adr, provider: User::Identity::LOCAL_PROVIDER, user_id: @current_user.id)
  end  
end

Pokud(/^zaloguju text "(.*?)"$/) do |text|
  logger.info(text)
end  


Pokud(/^u "(.*?)" existuje konexe "(.*?)"(?: s adresou "(.*?)")?$/) do |user_name, conn_name, conn_email|
  user=User.find_by_name(formalize_user_name(user_name))
  raise "User with name '#{user_name}' not found" if user.blank?

  make_connection_for(user,{ name: conn_name, email: conn_email })  
end

#===============================================

def make_connection_for(user,conn_hash)   
    conns= user.connections.find_by_name(conn_hash[:name])
    if conn_hash[:email].present?
     conns=conns.select {|conn| con.email == conn_hash[:email]} if conns.present?
    else
       conn_hash[:email]="#{conn_hash[:name]}@example.com"
    end  
  
  if conns.blank?
     #lets create it 
     user.connections << Connection.new(name: conn_hash[:name], email: conn_hash[:email])
     user.connections.reload
  elsif conns.size != 1
    raise "Ambiguous match for '#{conn_hash}' for user '#{user.username}': #{conns.join("\n")}"
  end  
end  


def formalize_user_name(user_name)
  case user_name
  when "pepika", "Pepika"
    "pepik"
  when "Mařenky"  
    "Mařenka"
  else
    user_name
  end  
end  
