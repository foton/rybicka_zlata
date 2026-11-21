def find_user_by(user_identificator)
  email = user_email_for_(user_identificator)
  @users.find { |u| u.email == email }
end

def user_email_for_(user_identificator)
  case user_identificator.downcase
  when 'bart', 'barta', 'bart@simpsons.com'
    'bart@simpsons.com'
  when 'lisa', 'líza', 'lízy', 'lisa@simpsons.com'
    'lisa@simpsons.com'
  when 'homer', 'homera', 'homer@simpsons.com'
    'homer@simpsons.com'
  when 'marge', 'marge', 'marge@simpsons.com'
    'marge@simpsons.com'
  when 'maggie', 'maggie@simpsons.com'
    'maggie@simpsons.com'
  else
    raise "Uncovered user for '#{user_identificator}'"
  end
end

# Replace the whole value of a text field.
# In Chrome, Selenium's default (select all, then type) sometimes appends to the old value,
# because send_keys moves the caret to the end; deleting it with backspaces is reliable.
def replace_field_value(field, text)
  if Capybara.current_driver == :rack_test
    field.set(text)
  else
    field.set(text, clear: :backspace)
  end
end
