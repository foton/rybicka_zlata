require 'test_helper'

class GoogleExtractorTest < ActiveSupport::TestCase

  def setup
     @auth_data = OmniAuth::AuthHash.new({ provider: "google", uid: "123456",
      info: OmniAuth::AuthHash.new({ 
         email: "john.doe@gmail.com", 
         first_name: "John",
         image: "https://lh5.googleusercontent.com/-K-FYMfCDazg/AAAAAAAAAAI/AAAAAAAATug/WPHCQlEc-xM/photo.jpg",
         last_name: "Doe",
        }),
      extra: OmniAuth::AuthHash.new({
        raw_info: OmniAuth::AuthHash.new({
          email: "john.doe@gmail.com",  
          email_verified: "true",
          locale: 'en'})
        })
    })     
    @extractor=User::Identity::Extractor::Google.new(@auth_data)
  end

  def test_get_name
    assert_equal @auth_data.info.name, @extractor.name
  end  

  def test_get_verified_email
    assert_equal @auth_data.extra.raw_info.email, @extractor.verified_email
  end  

  def test_get_locale
    assert_equal @auth_data.extra.raw_info.locale, @extractor.locale
  end  

  def test_not_get_verified_email
    auth_data2=@auth_data.dup
    auth_data2.extra.raw_info.email_verified="not_true"
    extractor=User::Identity::Extractor::Google.new(auth_data2)
    
    assert_nil extractor.verified_email
  end  

end
