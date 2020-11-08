# frozen_string_literal: true

# FOR scope: 'email,public_profile', info_fields: 'name,email,locale,timezone,verified'
# omniauth.auth=#<OmniAuth::AuthHash
#   credentials=#<OmniAuth::AuthHash
#     expires=true
#     expires_at=1457692938
#     token="CAAGXFKJWyUsBAEjBClWTuJQgADPh8hqxyb1eGcvOpbXy8DScAGyGnJH84CaNy7Kz7D0ZBRG0JuW7ldch2XjTxlZCZABhABBRRTVlUo2kubqGorSlB58ijUUOutTpNpNHZCZBbF10Q3BZBQ06ZBEmlfa7F0Piisk8eW5AoAUEBh4LGhbjg27tZBH9STAbZBZBSJZAHMZD"
#   >
#   extra=#<OmniAuth::AuthHash
#     raw_info=#<OmniAuth::AuthHash
#       email="porybny@rybickazlata.cz"
#       id="117054972007151"
#       locale="cs_CZ"
#       name="Porybný Rybičkozlatý"
#       timezone=1
#       verified=true
#     >
#   >
#   info=#<OmniAuth::AuthHash::InfoHash
#     email="porybny@rybickazlata.cz"
#     image="http://graph.facebook.com/117054972007161/picture"
#     name="Porybný Rybičkozlatý"
#     verified=true
#   >
#   provider="facebook"
#   uid="117054972007151"
# >

# Extracts data (name, verfified_email, locale) from Google+ OAuth2 hash
class User::Identity::Extractor::Facebook < User::Identity::Extractor
  def name
    @name ||= @auth_data.info.name
  end

  def locale
    @locale ||= raw_info.locale.split('_').first
  end

  def email
    @email ||= @auth_data.info.email
  end

  def verified_email
    unless defined? @verified_email
      @verified_email = nil
      @verified_email = raw_info.email if raw_info&.email && raw_info.verified == 'true'
    end
    @verified_email
  end

  def time_zone
    ActiveSupport::TimeZone[raw_info.timezone].name
  rescue StandardError
    nil
    # ofset is in hours from UTC, selecting first TZ which match
  end

  private

  def raw_info
    @auth_data&.extra && @auth_data.extra.raw_info ? @auth_data.extra.raw_info : nil
  end
end
