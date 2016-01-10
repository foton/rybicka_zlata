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

Pokud(/^existuje kontakt "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Pokud(/^existuje skupina "(.*?)" se členy \["(.*?)", "(.*?)","(.*?)"\]$/) do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
end

Pokud(/^mám mezi kontakty adresu "(.*?)"$/) do |adr|
  id=@current_user.identities.where(email: adr).first
  if id.blank?
    User::Identity.create!(email: adr, provider: User::Identity::LOCAL_PROVIDER, user_id: @current_user.id)
  end  
end



