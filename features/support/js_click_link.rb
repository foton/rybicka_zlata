# frozen_string_literal: true

def js_click_link(link_name)
  links_with_text = "a:contains(\"#{link_name}\")"
  links_with_id = "a[id=\"#{link_name}\"]"
  click_command = "$('#{links_with_text},#{links_with_id}').click()"
  raise Capybara::Webkit::ClickFailed unless evaluate_script %($('#{links_with_text},#{links_with_id}').length > 0)
  execute_script click_command
end
