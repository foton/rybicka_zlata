ActionMailer::Base.smtp_settings = {
  user_name: ENV['SMTP_USER'],
  # password: ENV['SMTP_PASSWORD'],
  password: ENV['SMTP_API_KEY'], # is the password for the SMTP server
  # domain: 'rybickazlata.cz',
  address: ENV['SMTP_SERVER'],
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
