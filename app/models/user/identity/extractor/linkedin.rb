# frozen_string_literal: true

# #<OmniAuth::AuthHash
#   credentials=#<OmniAuth::AuthHash
#     expires=true
#     expires_at=1457706569
#     token="AQUnfza9-5O2EREcPxpMBinsyRGk5GtkNJW5seupAZSubjqsDK1I-YQabZGIKX0_N-ZxNeIPsTsjtLgbEU0h0iP2ld5eeqDax0JzXAJAPvPCl0Qziy4XGTr3rfha469hWUdWmVUNYGwNemJQL8TudZ3BOpaj7UvaFigmup5MGcCAmSRsc-4"
#   >
#   extra=#<OmniAuth::AuthHash
#     raw_info=#<OmniAuth::AuthHash
#       emailAddress="foton@centrum.cz"
#       firstName="Petr"
#       headline="programmer Ruby on Rails, CIO"
#       id="SzOb06gvYk"
#       industry="Financial Services"
#       lastName="Mlčoch"
#       location=#<OmniAuth::AuthHash
#         country=#<OmniAuth::AuthHash
#           code="cz"
#         >
#         name="District Olomouc, Czech Republic"
#       >
#       pictureUrl="https://media.licdn.com/mpr/mprx/0_fDcXEjwcCo3FeyuXDfXBEYedCHnoeyuXS7iUEYWcgDCVB4Uk_IFHXOjJuQ9zIUSHaazV5JUgVJ65"
#       publicProfileUrl="https://www.linkedin.com/in/petrmlcoch"
#     >
#   >
#   info=#<OmniAuth::AuthHash::InfoHash
#     description="programmer Ruby on Rails, CIO"
#     email="foton@centrum.cz"
#     first_name="Petr"
#     image="https://media.licdn.com/mpr/mprx/0_fDcXEjwcCo3FeyuXDfXBEYedCHnoeyuXS7iUEYWcgDCVB4Uk_IFHXOjJuQ9zIUSHaazV5JUgVJ65"
#     last_name="Mlčoch"
#     location=#<OmniAuth::AuthHash
#       country=#<OmniAuth::AuthHash
#         code="cz"
#       >
#       name="District Olomouc, Czech Republic"
#     >
#     name="Petr Mlčoch"
#     nickname="Petr Mlčoch"
#     urls=#<OmniAuth::AuthHash
#       public_profile="https://www.linkedin.com/in/petrmlcoch"
#     >
#   >
#   provider="linkedin"
#   uid="SzOb06gvYk"
# >

class User::Identity::Extractor::Linkedin < User::Identity::Extractor
  def name
    @name ||= (@auth_data.info.name.present? ? @auth_data.info.name : @auth_data.info.nickname)
  end

  def locale
    nil
  end

  def email
    @email ||= @auth_data.info.email
  end

  def verified_email
    nil
  end

  def time_zone
    nil
  end
end
