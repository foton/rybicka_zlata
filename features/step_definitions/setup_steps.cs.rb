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
  #frienship.fullname : Ježíšek [???]: jezisek@rybickazlata.cz
  conns= @current_user.connections.select {|fshp| fshp.fullname == connection_fullname}
  
  if conns.blank?
     #lets create it 
     if m=connection_fullname.strip.match(/\A(.*) \[.*\]: (.*)\z/)
       @current_user.connections << Connection.new(name: m[1], email: m[2])
       @current_user.connections.reload
     else
       raise "Unable to parse connection from fullname '#{connection_fullname}'"
     end
  elsif conns.size != 1
    raise "Ambiguous match for '#{connection_fullname}': #{conns.join("\n")}"
  end  

end

Pokud(/^existuje konexe "(.*?)"$/) do |connection_name|
  conns= @current_user.connections.select {|fshp| fshp.name == connection_name}
  
  if conns.blank?
     #lets create it 
     @current_user.connections << Connection.new(name: connection_name, email: "#{connection_name}@example.com")
     @current_user.connections.reload
  elsif conns.size != 1
    raise "Ambiguous match for '#{connection_name}': #{conns.join("\n")}"
  end  

end

Pokud(/^existuje skupina "(.*?)" se členy \[([^\]]*)\]$/) do |grp_name, grp_members_to_s|
  grp=@current_user.groups.find_by_name(grp_name)
  if grp.blank?
    grp=@current_user.groups.create!( name: grp_name)
  end  

  members=[]
  for mem_name in grp_members_to_s.split(",")
    mem_name=mem_name.gsub("\"","").strip
    conn=@current_user.connections.find_by_name(mem_name)
    conn=@current_user.connections.create!(name: mem_name, email: "#{mem_name}@example.com") if conn.blank?
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


