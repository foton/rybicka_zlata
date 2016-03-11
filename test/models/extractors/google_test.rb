require 'test_helper'
require 'omni_auth_helper'

class GoogleExtractorTest < ActiveSupport::TestCase

  def setup
    @auth_data = google_oauth_hash
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
