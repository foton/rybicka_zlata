module WishesHelper
  def path_to_wish_action_for_user(wish, action, user)
    if user.is_author_of?(wish)
      base_path="user_author_wish_path"
    elsif user.is_donee_of?(wish)  
      base_path="user_my_wish_path"
    elsif user.is_donor_of?(wish)  
      base_path="user_others_wish_path"
    else  
      return ""
    end 

    case action.to_sym
    when :edit
      prefix="edit_"
    when :new
      prefix="new_"  
    else  
      prefix=""  
    end
    
    send("#{prefix}#{base_path}", user, wish)  
  end    
end
