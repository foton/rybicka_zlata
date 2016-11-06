#encoding: utf-8

Pak(/^můžu rovnou přidat další přání$/) do
	#find(".new", text: "Přidat další přání").click()
	find(".new").click()
	#should take me to New wish
	find("#new_wish")
end
