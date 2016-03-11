require 'test_helper'
require 'omni_auth_helper'

class TwitterExtractorTest < ActiveSupport::TestCase

  def setup
    @auth_data = twitter_oauth_hash
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
