# frozen_string_literal: true

# #google
#   #<OmniAuth::AuthHash
#    credentials=#<OmniAuth::AuthHash
#      expires=true
#      expires_at=1452010200
#      token="ya29.YAJHtuG0WYLsJIk4bndnKlU-9xJw1gEfpJ_toApOnNOuHKvP5nK0nKdrsD7Zd4jAO04Q"
#    >
#    extra=#<OmniAuth::AuthHash
#      id_info=#<OmniAuth::AuthHash
#        at_hash="W8T4Tl27O9Q5ts1b5U6LiQ"
#        aud="880659775345-s0v322g8tkv48n89r7f25kdaojjfd5th.apps.googleusercontent.com"
#        azp="880659775345-s0v322g8tkv48n89r7f25kdaojjfd5th.apps.googleusercontent.com"
#        email="john.doe@gmail.com"
#        email_verified=true
#        exp=1452010201
#        iat=1452006601
#        iss="accounts.google.com"
#        sub="114639699759279631155"
#      >
#      id_token="eyJhbGciOiJSUzI1NiIsImtpZCI6IjMyN2ZhM2M0ZGI4MmExNjI0ODFjZGQzNzdjMWFkNTU2NWNhZDZkODEifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXRfaGFzaCI6Ilc4VDRUbDI3TzlRNXRzMWI1VTZMaVEiLCJhdWQiOiI4ODA2NTk3NzUzNDUtczB2MzIyZzh0a3Y0OG44OXI3ZjI1a2Rhb2pqZmQ1dGguYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTQ2Mzk2OTk3NTkyNzk2MzExNTciLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXpwIjoiODgwNjU5Nzc1MzQ1LXMwdjMyMmc4dGt2NDhuODlyN2YyNWtkYW9qamZkNXRoLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiZW1haWwiOiJmb3Rvbi5tbmRwQGdtYWlsLmNvbSIsImlhdCI6MTQ1MjAwNjYwMSwiZXhwIjoxNDUyMDEwMjAxfQ.uZlip9t6y8yht9DeVL-LCmk40K8LJEVupIvzr-O87_-qm_E2KsrK4x78Nmbp9roqp6EAtMlPaxO_VzOwfuyyWzHbwTAhDbGupKqOMmMhdPJ7hfFPwBX9V3oo-6amujMCIQPix1vR1pj9iV8d_1TftDLzcNybwcbckAhulfKjbIH2mK83Fdin_yL_QHkJj82hTeG7qby-71Z_zi7SHx8K9U4fEL4vNqVOq--SLpLlw1kclI4SHigirw9_8PHBVg1BsRY0NTMI4v2ZmkQ5tvNfvvM1Ime-ZN0Pq1nbte71fzPi0ju-MdlXJgZ8_m9c2oM_a6cd2N7F-T_GCejjkvvrmA"
#      raw_info=#<OmniAuth::AuthHash
#        email="joh.doe@gmail.com"
#        email_verified="true"
#        family_name="Doe"
#        given_name="John"
#        kind="plus#connectionOpenIdConnect"
#        locale="cs"
#        name="John Doe"
#        picture="https://lh5.googleusercontent.com/-K-FYMfCDazg/AAAAAAAAAAI/AAAAAAAATug/WPHCQlEc-xM/photo.jpg?sz=50"
#        profile="https://plus.google.com/114639699759279631155"
#        sub="114639699759279631155"
#      >
#   >
#   info=#<OmniAuth::AuthHash::InfoHash
#     email="john.doe@gmail.com"
#     first_name="John"
#     image="https://lh5.googleusercontent.com/-K-FYMfCDazg/AAAAAAAAAAI/AAAAAAAATug/WPHCQlEc-xM/photo.jpg"
#     last_name="Doe"
#     name="John Doe"
#     urls=#<OmniAuth::AuthHash
#       Google="https://plus.google.com/114639699759279631155"
#     >
#   >
#   provider="google"
#   uid="114639699759279631155"
# >

# Extracts data (name, verfified_email, locale) from Google+ OAuth2 hash
class User::Identity::Extractor::Google < User::Identity::Extractor
  def name
    @name ||= @auth_data.info.name
  end

  delegate :locale, to: :raw_info

  def email
    @email ||= @auth_data.info.email
  end

  def verified_email
    unless defined? @verified_email
      @verified_email = nil
      @verified_email = raw_info.email if raw_info&.email && raw_info.email_verified == 'true'
    end
    @verified_email
  end

  private

  def raw_info
    @auth_data&.extra && @auth_data.extra.raw_info ? @auth_data.extra.raw_info : nil
  end
end
