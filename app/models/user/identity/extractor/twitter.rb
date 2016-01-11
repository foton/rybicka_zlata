# omniauth.auth=#<OmniAuth::AuthHash 
#   credentials=#<OmniAuth::AuthHash 
#     secret="3xygB04Xp6GlzUIhSbtFcfG9Xx8B2UBk4ZEUOrTaNvF5P" 
#     token="4773047955-70aAhcPZW28YoiT7zlCNxRmzmr3jF195cH96tRn"
#   >
#   extra=#<OmniAuth::AuthHash 
#     access_token=#<OAuth::AccessToken:0x007f3fadabf4e8    ---- some very secret infos ---- >
#     raw_info=#<OmniAuth::AuthHash 
#       contributors_enabled=false 
#       created_at="Mon Jan 11 10:00:26 +0000 2016" 
#       default_profile=true 
#       default_profile_image=false 
#       description="" 
#       entities=#<OmniAuth::AuthHash 
#         description=#<OmniAuth::AuthHash 
#           urls=[]
#         >
#       > 
#       favourites_count=0 
#       follow_request_sent=false 
#       followers_count=0 
#       following=false 
#       friends_count=0 
#       geo_enabled=false 
#       has_extended_profile=false 
#       id=4773047955 
#       id_str="4773047955" 
#       is_translation_enabled=false 
#       is_translator=false 
#       lang="cs" 
#       listed_count=0 
#       location="" 
#       name="Porybný" 
#       notifications=false 
#       profile_background_color="F5F8FA" 
#       profile_background_image_url=nil 
#       profile_background_image_url_https=nil 
#       profile_background_tile=false 
#       profile_image_url="http://pbs.twimg.com/profile_images/686488216732626944/xr8Jqnh9_normal.jpg" 
#       profile_image_url_https="https://pbs.twimg.com/profile_images/686488216732626944/xr8Jqnh9_normal.jpg" 
#       profile_link_color="2B7BB9" 
#       profile_sidebar_border_color="C0DEED" 
#       profile_sidebar_fill_color="DDEEF6" 
#       profile_text_color="333333" 
#       profile_use_background_image=true 
#       protected=false 
#       screen_name="porybny_rz" 
#       statuses_count=0 
#       time_zone=nil 
#       url=nil 
#       utc_offset=nil 
#       verified=false
#     >
#   > 
#   info=#<OmniAuth::AuthHash::InfoHash 
#     description="" 
#     email=nil 
#     image="http://pbs.twimg.com/profile_images/686488216732626944/xr8Jqnh9_normal.jpg" 
#     location="" 
#     name="Porybný" 
#     nickname="porybny_rz" 
#     urls=#<OmniAuth::AuthHash 
#       Twitter="https://twitter.com/porybny_rz" 
#       Website=nil
#     >
#   >
#   provider="twitter" 
#   uid="4773047955"
# >

class User::Identity::Extractor::Twitter < User::Identity::Extractor
  
  def name
    @name||=(@auth_data.info.name.present? ? @auth_data.info.name : @auth_data.info.nickname)
  end

  def locale
   raw_info.lang
  end  

  def email
    @email||=@auth_data.info.email
  end

  def verified_email
    unless defined? @verified_email
      @verified_email= nil
      @verified_email = raw_info.email if (raw_info && raw_info.email && raw_info.verified == "true")
    end 
    @verified_email
  end

  def time_zone
    raw_info.time_zone
  end  


  private
  def raw_info
    (@auth_data && @auth_data.extra && @auth_data.extra.raw_info) ? @auth_data.extra.raw_info : nil
  end  
end
