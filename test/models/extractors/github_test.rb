require 'test_helper'

class GithubExtractorTest < ActiveSupport::TestCase

  def setup
     @auth_data = OmniAuth::AuthHash.new({ provider: "github", uid: "123456",
      info: OmniAuth::AuthHash.new({ 
         email: "john.doe@gmail.com", 
         name: "John Doe",
         nickname: "John_doe",
         image: "https://avatars.githubusercontent.com/u/483873?v=3"
        }),
    })     
    @extractor=User::Identity::Extractor::Github.new(@auth_data)
  end

  def test_get_name_when_present
    assert_equal @auth_data.info.name, @extractor.name
  end  

  def test_get_nickname_when_name_is_not_present
  	auth_data = @auth_data.dup
  	auth_data.info.name=nil
    extractor=User::Identity::Extractor::Github.new(auth_data)

    assert_equal @auth_data.info.nickname, extractor.name
  end  

  def test_get_verified_email
    assert_equal @auth_data.info.email, @extractor.verified_email
  end  

  def test_get_locale
    assert_nil @extractor.locale
  end  

end