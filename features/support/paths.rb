#encoding: utf-8
#language: cs

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name, desired_resource =nil)
    
    page_name =page_name.gsub("stránce ","")
    m=page_name.match(/\A"([^"]*)"\z/)
    page_name =m[1] if m

    case page_name
      when "úvodní stránce", "home page"
        root_path(locale: @locale)
      when "přihlašovací stránce", "přihlášení", "signin page", "login page", "sign_in"
        new_user_session_path(locale: @locale)
      when "Profil", "mé profilové stránce", "své stránce nastavení", "své stránce", "my profile"
        my_profile_path(locale: @locale)
      when "Lidé", "stránce Lidé", "Přátelé"
        user_connections_path(current_user, locale: @locale)
      when "Skupiny"
        user_groups_path(current_user, locale: @locale)
      when "Má přání"
        user_my_wishes_path(current_user, locale: @locale)
      when "Múžu splnit"
        user_others_wishes_path(current_user, locale: @locale)


      else
        if (m=page_name.match(/stránce editace (.*)/) || (m=page_name.match(/editace (.*)/) ) || m=page_name.match(/editaci (.*)/) )
           if m1=m[1].match(/kontaktu "([^"]*)"/)
             name=m1[1].to_s
             conn= Connection.find_by_name(name)
             raise "Connection with name '#{name}'' not found!" if conn.blank?
             edit_user_connection_path(current_user,conn,{locale: @locale})
           elsif m1=m[1].match(/skupiny "([^"]*)"/)
             name=m1[1].to_s
             grp= Group.find_by_name(name)
             raise "Group with name '#{name}'' not found!" if grp.blank?
             edit_user_group_path(current_user,grp,{locale: @locale})
           else
             raise "Edit Path not identified"      
           end  

        elsif m=page_name.match(/Skupina (.*)/)        
           grp=Group.find_by_name(m[1])
           user_group_path(current_user, grp, {locale: @locale})

        elsif m=page_name.match(/přání uživatele (.*)/)        
           user=User.find_by_name(m[1].gsub("\"","").strip)
           user_my_wishes_path(user, locale: @locale)

        elsif m=page_name.match(/Přání '(.*)'\z/)        
           wishes=(current_user.donee_wishes.where(title: m[1]).to_a+current_user.donor_wishes.where(title: m[1]).to_a)
           raise "Wish '#{m[1]}' was not found between wishes os user #{current_user.displayed_name}" if wishes.blank?
           user_my_wish_path(current_user, wishes.first, locale: @locale)


      #   if m=page_name.match(/přehledu? (.*)/) # melo by zachytit "přehled "Moje dárky " i "přehledu mých přání"
      #     case m[1]
      #       when "\"Moje přání\"", "mých přání"
      #       my_wishes_path(locale: @locale)
      #     when "pro dárce", "cizích přání", "přání co mohu splnit"
      #       others_wishes_path(locale: @locale)
      #     end
      #   elsif (m=page_name.match(/stránce editace (.*)/) || m=page_name.match(/editaci (.*)/) )
      #     if m1=m[1].match(/kontaktu "([^"]*)"/)
      #       name=m1[1].to_s
      #       contact= FriendContact.find_by_name(name)
      #       raise "Contact #{name} not found!" if contact.blank?
      #       edit_friend_contact_path(contact,{locale: @locale})
      #     end  
        else  
          raise "Path not identified"
        end  
    end    
  end

  def current_path
    URI.parse(current_url).path
  end

end


World(NavigationHelpers)
