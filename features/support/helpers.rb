def find_user_by(user_identificator)
  email = user_email_for_(user_identificator)
  @users.find { |u| u.email == email}
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

