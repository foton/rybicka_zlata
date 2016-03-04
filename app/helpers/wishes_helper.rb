module WishesHelper
  def path_to_wish_action_for_user(action, user, wish=nil ,params ={})

    return new_user_author_wish_path(user) if (action == :new)
    return "" if wish.blank?
    
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
    else  
      prefix=""  
    end
    
    send("#{prefix}#{base_path}", user, wish, params)  
  end    

  def button_to_wish_action(action, user, wish=nil, params={})
    if [:new,:show, :edit].include?(action)
      method= :get
    elsif [:delete,:destroy].include?(action)
      method= :delete
    else  
      method= :patch
    end  
    
    wid = "wish_#{action}" 
    wid+="_#{wish.id}" if wish.present?
    bt_content= I18n.t("wish.actions.#{action}.button")
    tooltip=I18n.t("wish.actions.#{action}.button")
    url=path_to_wish_action_for_user(action, user, wish, params)
    if (action == :delete)
      data= { 
                confirm: t("wish.actions.delete.confirm.message", wish_title: wish.title), 
                #keys are with '-', for consistency
                #if underscore is used 'confirm_yes', still dashed 'data-confirm-yes = "YES"' is generated in html
                "confirm-yes": t("confirm.yes"), 
                "confirm_no": t("confirm.no")
              }
    else
      data={}          
    end         
    
    content_tag(:span) do
      concat button_link_to( bt_content, url, {method: method, id: wid, class: action.to_s, data: data } )
      concat content_tag(:span, class: "mdl-tooltip", for: wid) { I18n.t("wish.actions.#{action}.button") }  if bt_content != tooltip
    end  
  end 
end
