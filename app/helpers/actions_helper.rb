module ActionsHelper
  
  def classes_for(obj, user)
    id_cls=anchor_for(obj)
    if obj.kind_of?(Wish::FromDonor)
      id_cls+" wish "+donor_class_for_state(obj, user)
    elsif obj.kind_of?(Wish)
       if user.is_donor_of?(obj)
         id_cls+" wish "+donor_class_for_state(obj, user)
       else 
         id_cls+" wish"
       end
    elsif obj.kind_of?(User::Identity)  
      id_cls+" contact"
    elsif obj.kind_of?(Group)  
      id_cls+" group"
    elsif obj.kind_of?(Connection)
      id_cls+" connection"
    else
      id_cls
    end  
  end 

  def anchor_for(obj)
    (obj.kind_of?(Wish) ? "wish" : obj.class.to_s).downcase.dasherize+"_"+obj.id.to_s
  end  
  
  def menu_button_anchor_for(obj)
    anchor_for(obj)+"--menu-button"
  end  


 # def button_to_wish_action(action, user, wish=nil, remote=false, params={})
 #    tag_link_to_action(:button, action, user, wish, remote, params)
 #  end 

  def tag_to_object_action(tag, action, user, obj=nil, remote=false, params={})
    #bt_content= I18n.t("#{controller_prefix(obj)}.actions.#{action}.button")
    #tooltip=I18n.t("#{controller_prefix(obj)}.actions.#{action}.button")
    text=I18n.t("#{controller_prefix(obj)}.actions.#{action}.button")
    action= :new if action == :another_new
    tag_to_object_action_with_text(tag, action, user, text, obj, remote, params)
  end

  def tag_to_object_action_with_text(tag, action, user, text, obj=nil, remote=false, params={})
  
    method, remote, data, params = prepare_params(action, user, obj, remote, params)
    
    id = controller_prefix(obj)+"_"+action.to_s 
    id+="_#{obj.id}" if obj.present?

    tooltip=bt_content=text
        
    url=path_to_action_for_user(action, user, obj, params)
    
    case tag
    when :a, :link
      mtd="link_to"
    when :button
      mtd="button_link_to"
    else
      raise "unknown TAG: #{tag}"
    end  
  
    content_tag(:span) do
      concat send(mtd, bt_content, url, {method: method, id: id, remote: remote, class: action.to_s, data: data } )
      concat content_tag(:span, class: "mdl-tooltip", for: id) { bt_content }  if bt_content != tooltip
    end  
  end  

  # def link_to_wish_action(action, user, wish=nil, remote=false, params={})
  #   tag_link_to_action(:a, action, user, wish, remote, params)
  # end 


  private

    def prepare_params(action, user, obj, remote, params)
      
      state_action= params.delete(:state_action)  

      if [:new,:show, :edit].include?(action)
        method= :get
        remote=false
      elsif [:delete,:destroy].include?(action)
        method= :delete
      else  
        method= :patch
        if obj.respond_to?(:available_state_actions_for) && obj.available_state_actions_for(user).include?(action) && !([:show].include?(action.to_sym))
          params.merge!({state_action: action})  
        end  
      end  

      if (action == :delete)
        data= { 
                confirm: t("#{controller_prefix(obj)}.actions.delete.confirm.message", object_title: (obj.respond_to?(:title) ? obj.title : obj.displayed_name) ), 
                #keys are with '-', for consistency
                #if underscore is used 'confirm_yes', still dashed 'data-confirm-yes = "YES"' is generated in html
                "confirm-yes": t("confirm.yes"), 
                "confirm_no": t("confirm.no")
                }
      else
        data={}          
      end      
      return method, remote, data, params
    end
     
    def controller_prefix(obj) 
      if obj.kind_of?(Wish)
        "wishes"
      elsif obj.kind_of?(User::Identity)  
        "user.identities"
      elsif obj.kind_of?(Group)  
        "groups"
      elsif obj.kind_of?(Connection)
        "connections"
      else
        ""
      end  
    end 

    def path_to_action_for_user(action, user, obj, params)
      if obj.kind_of?(Wish)
        path_to_wish_action_for_user(action, user, obj, params)
      else
        action=:destroy if action.to_sym == :delete
        if obj.kind_of?(User::Identity) 
          url_for(action: action, controller: 'users/identities', user_id: user.id, id: (obj.nil? ? nil : obj.id), params: params)
        else
          url_for(action: action, controller: controller_prefix(obj), user_id: user.id, id: (obj.nil? ? nil : obj.id), params: params)
        end  
      end  
    end  
end
