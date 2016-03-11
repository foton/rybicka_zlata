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

  def button_to_wish_action(action, user, wish=nil, remote=false, params={})
    if [:new,:show, :edit].include?(action)
      method= :get
      remote=false
    elsif [:delete,:destroy].include?(action)
      method= :delete
    else  
      method= :patch
    end  
    
    wid = "wishes_#{action}" 
    wid+="_#{wish.id}" if wish.present?
    bt_content= I18n.t("wishes.actions.#{action}.button")
    tooltip=I18n.t("wishes.actions.#{action}.button")
    url=path_to_wish_action_for_user(action, user, wish, params)
    if (action == :delete)
      data= { 
                confirm: t("wishes.actions.delete.confirm.message", wish_title: wish.title), 
                #keys are with '-', for consistency
                #if underscore is used 'confirm_yes', still dashed 'data-confirm-yes = "YES"' is generated in html
                "confirm-yes": t("confirm.yes"), 
                "confirm_no": t("confirm.no")
              }
    else
      data={}          
    end         
    
    content_tag(:span) do
      concat button_link_to( bt_content, url, {method: method, id: wid, remote: remote, class: action.to_s, data: data } )
      concat content_tag(:span, class: "mdl-tooltip", for: wid) { I18n.t("wishes.actions.#{action}.button") }  if bt_content != tooltip
    end  
  end 

  def link_to_wish_action(action, user, wish=nil, remote=false, params={})
    if [:new,:show, :edit].include?(action)
      method= :get
      remote=false
    elsif [:delete,:destroy].include?(action)
      method= :delete
    else  
      method= :patch
    end  
    
    wid = "wishes_#{action}" 
    wid+="_#{wish.id}" if wish.present?
    bt_content= I18n.t("wishes.actions.#{action}.button")
    tooltip=I18n.t("wishes.actions.#{action}.button")
    url=path_to_wish_action_for_user(action, user, wish, params)
    if (action == :delete)
      data= { 
                confirm: t("wishes.actions.delete.confirm.message", wish_title: wish.title), 
                #keys are with '-', for consistency
                #if underscore is used 'confirm_yes', still dashed 'data-confirm-yes = "YES"' is generated in html
                "confirm-yes": t("confirm.yes"), 
                "confirm_no": t("confirm.no")
              }
    else
      data={}          
    end         
    
    content_tag(:span) do
      concat link_to( bt_content, url, {method: method, id: wid, remote: remote, class: action.to_s, data: data } )
      concat content_tag(:span, class: "mdl-tooltip", for: wid) { I18n.t("wishes.actions.#{action}.button") }  if bt_content != tooltip
    end  
  end 

  def class_for_state(wish, user=current_user)
    if wish.available?
      "wish_available"
    elsif wish.booked?
      wish.booked_by?(user) ? "wish_me_as_donor" : "wish_reserved"
    elsif wish.call_for_co_donors?
      wish.called_by?(user) ? "wish_me_as_donor" : "wish_call-for-co-donors"
    elsif wish.gifted?
      wish.booked_by?(user) ? "wish_me_as_donor" : "wish_gifted"
    elsif wish.fulfilled?  
      "wish_fulfilled"
    else
      ""
    end  
  end  

  def icon_of_wish_sharing(wish)
    if wish.is_shared?
      icon="group"
      tooltip=I18n.t("wishes.shared_icon_tooltip.shared")
    else  
      icon="person"
      tooltip=I18n.t("wishes.shared_icon_tooltip.personal")
    end  
    w_id=wish.anchor+"_shared_icon"
    raw "<i class=\"material-icons shared-wish-icon\" id=\"#{w_id}\" >#{icon}</i><span class=\"mdl-tooltip\" for=\"#{w_id}\" >#{tooltip}</span>"
  end  

end
