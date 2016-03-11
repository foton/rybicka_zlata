require 'test_helper'
require 'omni_auth_helper'

class FacebookExtractorTest < ActiveSupport::TestCase

  def setup
    @auth_data = facebook_oauth_hash
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
