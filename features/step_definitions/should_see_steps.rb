#encoding: utf-8

Then /^(?:bych měl|měl bych) vidět (?:text )?"([^"]*)"$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath('//*', :text => regexp)
  else
    assert page.has_xpath?('//*', :text => regexp)
  end
end

