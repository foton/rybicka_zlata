require 'test_helper'

class FacebookExtractorTest < ActiveSupport::TestCase

  def setup
     @auth_data = OmniAuth::AuthHash.new({ provider: "facebook", uid: "123456",
      info: OmniAuth::AuthHash.new({ 
         email: "john.doe@gmail.com", 
         name: "John Doe",
         image: "http://graph.facebook.com/117054972007161/picture",
        }),
      extra: OmniAuth::AuthHash.new({
        raw_info: OmniAuth::AuthHash.new({
          email: "john.doe@gmail.com",  
          locale: 'cs_CZ',
          name: "John Doe",
          timezone: 1,  #Prague/Amsterdam?  FB-dev: float (min: -24) (max: 24) The person's current timezone offset from UTC
          verified: "true"
          })
        })
    })     
    @extractor=User::Identity::Extractor::Facebook.new(@auth_data)
  end

  def test_get_name
    assert_equal @auth_data.info.name, @extractor.name
  end  

  def test_get_verified_email
    assert_equal @auth_data.extra.raw_info.email, @extractor.verified_email
  end  

  def test_get_locale
    assert_equal @auth_data.extra.raw_info.locale.split("_").first, @extractor.locale
  end  

  def test_not_get_verified_email
    auth_data2=@auth_data.dup
    auth_data2.extra.raw_info.verified="not_true"
    extractor=User::Identity::Extractor::Facebook.new(auth_data2)
    
    assert_nil extractor.verified_email
  end  

  def test_get_correct_timezone
    fb_timezone_offset_in_hours= @auth_data.extra.raw_info.timezone
    tz_from_fb=ActiveSupport::TimeZone[fb_timezone_offset_in_hours].name #=> 'Amsterdam'
    assert_equal tz_from_fb, @extractor.time_zone
    assert_equal "Amsterdam", @extractor.time_zone
  end  

end
