# frozen_string_literal: true

require 'test_helper'
require 'url_regexp.rb' # from lib/url_regexp.rb
class UrlRgexpTest < ActiveSupport::TestCase
  [
    'http://✪df.ws/123',
    'http://userid:password@example.com:8080',
    'http://userid:password@example.com:8080/',
    'http://userid@example.com',
    'http://userid@example.com/',
    'http://userid@example.com:8080',
    'http://userid@example.com:8080/',
    'http://userid:password@example.com',
    'http://userid:password@example.com/',
    'http://142.42.1.1/',
    'http://142.42.1.1:8080/',
    'http://➡.ws/䨹',
    'http://⌘.ws',
    'http://⌘.ws/',
    'http://foo.com/blah_(wikipedia)#cite-1',
    'http://foo.com/blah_(wikipedia)_blah#cite-1',
    'http://foo.com/unicode_(✪)_in_parens',
    'http://foo.com/(something)?after=parens',
    'http://☺.damowmow.com/',
    'http://code.google.com/events/#&product=browser',
    'http://j.mp',
    'ftp://foo.bar/baz',
    'http://foo.bar/?q=Test%20URL-encoded%20stuff',
    'http://مثال.إختبار',
    'http://例子.测试'
  ].each do |valid_url|
    test "matches #{valid_url}" do
      assert valid_url.match(Regexp::PERFECT_URL_PATTERN)
    end
  end

  [
    'http://',
    'http://.',
    'http://..',
    'http://../',
    'http://?',
    'http://??',
    'http://??/',
    'http://#',
    'http://##',
    'http://##/',
    'http://foo.bar?q=Spaces should be encoded',
    '//',
    '//a',
    '///a',
    '///',
    'http:///a',
    'foo.com',
    'rdar://1234',
    'h://test',
    'http:// shouldfail.com',
    ':// should fail',
    'http://foo.bar/foo(bar)baz quux',
    'ftps://foo.bar/',
    'http://-error-.invalid/',
    'http://a.b--c.de/',
    'http://-a.b.co',
    'http://a.b-.co',
    'http://0.0.0.0',
    'http://10.1.1.0',
    'http://10.1.1.255',
    'http://224.1.1.1',
    'http://1.1.1.1.1',
    'http://123.123.123',
    'http://3628126748',
    'http://.www.foo.bar/',
    'http://www.foo.bar./',
    'http://.www.foo.bar./',
    'http://10.1.1.1',
    'http://10.1.1.254'
  ].each do |invalid_url|
    test "does not match #{invalid_url}" do
      refute invalid_url.match(Regexp::PERFECT_URL_PATTERN)
    end
  end

  # def test_break_down_important_parts
  #   parts=[
  #       "http://",
  #       "www.ss.ddd.cxx",
  #       ":80",
  #       "/users/111",
  #       "?a=x&b=1%20apl"
  #   ]
  #   url= parts.join("")
  #   assert_equal "http://www.ss.ddd.cxx:80/users/111?a=x&b=1%20apl", url
  #   binding.pry

  #   m=url.match(Regexp::PERFECT_URL_PATTERN)

  #   assert url, m[0]
  #   parts.each_with_index do |part, i|
  #       assert_equal part, m[i+1]
  #   end
  # end
end
