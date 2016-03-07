require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  def test_shortening_of_uri
    uris =[]
     
    uris << ["http://www.ss.ddd.cxx:80/users/111?a=x&b=1%20apls",  "http://www.ss.ddd.cxx:80/users/111?a=x&b=1%20apls"] #50 chars
    uris << ["http://www.ss.ddd.cxx:80/users/111?a=x&b=1%20aplsd",  "www.ss.ddd.cxx...(zkráceno)"] #51 chars
    uris << ["http://www.ss.ddd.cxx:80/users/11sdasdasdadasdadsdasd?a=x&b=1%20apl&dasjkjaksd=8979797&hhhhh=uuuuuuuuu&i=123456789012345678901234567890", "www.ss.ddd.cxx...(zkráceno)"]

    for uri in uris
      assert_equal link_to(uri.last, uri.first), short_link_from_uri(uri.first)
    end  
  end  

  def test_convert_str_to_clickable_html
    text=         "This is some text with \n new lines \n and <p> <h1> HTML tags and URI to http://www.ss.ddd.cxx:80/users/111?a=x&b=1%20apls and http://www.ss.ddd.cxx:80/users/111?a=x&b=1%20aplsd"
    expected_text="This is some text with <br /> new lines <br /> and &lt;p&gt; &lt;h1&gt; HTML tags"
    expected_text+=" and URI to <a href=\"http://www.ss.ddd.cxx:80/users/111?a=x&amp;b=1%20apls\">http://www.ss.ddd.cxx:80/users/111?a=x&amp;b=1%20apls</a>"
    expected_text+=" and <a href=\"http://www.ss.ddd.cxx:80/users/111?a=x&amp;b=1%20aplsd\">www.ss.ddd.cxx...(zkráceno)</a>"
    assert_equal expected_text, to_html(text)               
  end  
end  
