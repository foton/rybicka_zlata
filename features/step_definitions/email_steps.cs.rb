Pokud(/^si otevřu poslední email pro adresu "(.*?)"$/) do |email_addr|
  @email=(ActionMailer::Base.deliveries.select {|em| em.to.include?(email_addr)}).last
  @email.body #to raise error if @email is nil
end

require 'nokogiri'
#require 'uri'

Pokud(/^kliknu v emailu na odkaz "(.*?)"$/) do |link_text|

  doc = Nokogiri::HTML.parse(@email.body.encoded)
  links=doc.css("a").select {|link| link.text == link_text}
  if links.size == 0
    raise "No link with text '#{link_text} found in #{@email.body.encoded}"
  elsif links.size > 1
    raise "More than 1 link with text '#{link_text} found in #{@email.body.encoded}"
  else  
    uri=URI.parse(links.first['href']) # with localhost => "http://localhost:3000/users/confirmation?confirmation_token=z8-qzo-uhreXaVu7CXXA
  end      
  relative_url=uri.to_s
  relative_url=relative_url.gsub("#{uri.scheme}://","") if uri.scheme.present?
  relative_url=relative_url.gsub(uri.userinfo,"") if uri.userinfo.present?
  relative_url=relative_url.gsub(uri.host,"") if uri.host.present?
  relative_url=relative_url.gsub(":#{uri.port}","") if uri.port.present?

  visit relative_url
end

Pak(/^uživatelům, kteří ji používali o tom přijde e\-mail$/) do
  pending # express the regexp above with the code you wish you had
end


Pak(/^jeho předmět by měl být "([^"]*)"$/) do |subject|
  assert_equal subject, @email.subject, "Subject expected: #{subject}, actual: #{@email.subject}"
  
end

Pak(/^v jeho obsahu by mělo být "([^"]*)"$/) do |text|
  assert @email.body.include?(text), "Expected: #{text} in email.body: #{@email.body}"
end

