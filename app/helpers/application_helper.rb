module ApplicationHelper
  
  def set_page_title(page_title)  #version page_title=(pg) does not work, it set local variable instead in view
    content_for(:title) { page_title }
  end

  def page_title
    content_for?(:title) ? content_for(:title) : (t("rybickazlata.name")+" "+t("rybickazlata.title"))
  end  

  def mdl_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end
  
  #https://gist.github.com/suryart/7418454
  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{mdl_class_for(msg_type)} mdl-cell mdl-cell--12-col") do 
               #concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
               concat message 
             end)
      end
    nil
  end

  def header(text)
    content_tag(:h3, text)
  end  


  def switch_for( f_builder, method, label_text=nil, options ={}, html_options={}, checked_value = "1", unchecked_value = "0")
    label_text= t("activerecord.attributes.#{f_builder.object.class.name.downcase}.#{method}") if label_text.blank? && f_builder.object.kind_of?(ActiveRecord::Base)

    f_builder.label(method, nil, options.merge({class: "mdl-switch mdl-js-switch mdl-js-ripple-effect"}) ) do
      concat(f_builder.check_box(method, options.merge(html_options.merge({ class: "mdl-switch__input" }) ), checked_value, unchecked_value) )
      concat(content_tag(:span, label_text, class:"mdl-switch__label") )  
    end
  end

  def checkbox_mdl_tag( tag_id, label_text, check_status, checked_value = "1", unchecked_value = "0", options ={})
    label_tag( nil, options.merge({class: "mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect"}) ) do
      concat(check_box_tag( tag_id, checked_value, check_status, options.merge(options.merge({class: "mdl-checkbox__input"}) )) )
      concat(content_tag(:span, label_text, class:"mdl-checkbox__label") )  
    end
  end

  def form_submit_button(text=nil)
    button_tag( class: "button-save mdl-button mdl-js-button mdl-button--fab mdl-button--colored mdl-js-ripple-effect" ) do 
      text ||"<i class=\"material-icons\">check</i>".html_safe
    end
  end
  
  def form_next_button(text=nil)
    button_tag( class: "button-save mdl-button mdl-js-button mdl-button--fab mdl-button--colored mdl-js-ripple-effect" ) do 
      text ||"<i class=\"material-icons\">forward</i>".html_safe
    end
  end

  def add_new_button(text=nil)
    button_tag( class: "button-add mdl-button mdl-js-button mdl-button--fab mdl-button--colored mdl-js-ripple-effect" ) do 
        text ||"<i class=\"material-icons\">add</i>".html_safe
    end
  end  

end
