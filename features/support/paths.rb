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
    case page_name
    when "úvodní stránce", "home page"
      root_path(locale: @locale)
    when "přihlašovací stránce", "přihlášení", "signin page", "login page", "sign_in"
      new_user_session_path(locale: @locale)
    when "mé stránce nastavení", "své stránce nastavení", "své stránce", "my profile"
      my_page_path(locale: @locale)
    when "stránce uživatele"
       user_home_page_path(desired_resource, {locale: @locale})
    else
    
      if m=page_name.match(/přehledu? (.*)/) # melo by zachytit "přehled "Moje dárky " i "přehledu mých přání"
        case m[1]
          when "\"Moje přání\"", "mých přání"
          my_wishes_path(locale: @locale)
        when "pro dárce", "cizích přání", "přání co mohu splnit"
          others_wishes_path(locale: @locale)
        end
      elsif (m=page_name.match(/stránce editace (.*)/) || m=page_name.match(/editaci (.*)/) )
        if m1=m[1].match(/kontaktu "([^"]*)"/)
          name=m1[1].to_s
          contact= FriendContact.find_by_name(name)
          raise "Contact #{name} not found!" if contact.blank?
          edit_friend_contact_path(contact,{locale: @locale})
        end  
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
