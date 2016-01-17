require 'test_helper'

class TwitterExtractorTest < ActiveSupport::TestCase

  def setup
     @auth_data = OmniAuth::AuthHash.new({ provider: "twitter", uid: "123456",
      info: OmniAuth::AuthHash.new({ 
         email: "john.doe@gmail.com", 
         name: "John Doe",
         nickname: "john_doe",
         image: "http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
        }),
      extra: OmniAuth::AuthHash.new({
        raw_info: OmniAuth::AuthHash.new({
          email: "john.doe@gmail.com",  
          lang: 'en',
          time_zone: 'Chicago',
          name: "John Doe",
          verified: "true"
          })
        })
    })     
    @extractor=User::Identity::Extractor::Twitter.new(@auth_data)
  end

  def test_get_name
    assert_equal @auth_data.info.name, @extractor.name
  end  

  def test_get_nickname_as_name_when_name_is_blank
    auth_data2=@auth_data.dup
    auth_data2.info.name=""
    extractor=User::Identity::Extractor::Twitter.new(auth_data2)

    assert_equal @auth_data.info.nickname, extractor.name
  end  


  def test_get_verified_email
    assert_equal @auth_data.extra.raw_info.email, @extractor.verified_email
  end  

  def test_get_locale
    assert_equal @auth_data.extra.raw_info.lang, @extractor.locale
  end  

  def test_not_get_verified_email
    auth_data2=@auth_data.dup
    auth_data2.extra.raw_info.verified="not_true"
    extractor=User::Identity::Extractor::Twitter.new(auth_data2)
    
    assert_nil extractor.verified_email
  end  

  def test_get_correct_timezone
    assert_equal @auth_data.extra.raw_info.time_zone, @extractor.time_zone
  end  

end
