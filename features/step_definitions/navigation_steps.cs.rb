#encoding: utf-8

Given /^jsem na (.*)$/ do |kde|
	new_path=path_to(kde)
	unless (current_path == new_path)
    visit new_path
  end
end



