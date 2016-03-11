require 'test_helper'
require 'omni_auth_helper'

class LinkedinExtractorTest < ActiveSupport::TestCase

  def setup
    @auth_data = linkedin_oauth_hash
    @extractor=User::Identity::Extractor::Linkedin.new(@auth_data)
  end

  def test_get_name_when_present
    assert_equal @auth_data.info.name, @extractor.name
  end  

  def test_get_nickname_when_name_is_not_present
    auth_data = @auth_data.dup
    auth_data.info.name=nil
    extractor=User::Identity::Extractor::Linkedin.new(auth_data)

    assert_equal @auth_data.info.nickname, extractor.name
  end  

  def test_get_email
    assert_equal @auth_data.info.email, @extractor.email
  end  

  def test_get_verified_email
    assert_nil @extractor.verified_email
  end  

  def test_get_locale
    assert_nil @extractor.locale
  end  

  def test_get_time_zone
    assert_nil @extractor.time_zone
  end  

end
