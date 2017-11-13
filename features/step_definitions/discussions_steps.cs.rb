Pak("bych měl vidět formulář na první příspěvek") do
  pending # Write code here that turns the phrase above into concrete actions
end

Pak("bych měl vidět příspěvek {string} od {string}") do |obsah, username|
  step("měl bych vidět text \"#{obsah}\"")
end

Pak("měl bych vidět příspěvek {string} od {string}") do |obsah, username|
  step("měl bych vidět text \"#{obsah}\"")
end

Pak("bych neměl vidět příspěvek {string} od {string}") do |obsah, username|
  step("neměl bych vidět text \"#{obsah}\"")
end

Pokud("otevřu si přání {string} u {string}") do |wish_title, username|
  step('jsem na stránce "Můžu splnit"')
  step("pokud si otevřu přání \"#{wish_title}\" u \"#{username}\"")
end

Pokud("přidám příspěvek {string}") do |text|
  pending # Write code here that turns the phrase above into concrete actions
end

Pokud("přidám příspěvek {string} s označením {string}") do |text, flag_text|
  pending # Write code here that turns the phrase above into concrete actions
end

Pokud("se přihlásím jako {string}") do |username|
  step("odhlásím se")
  step("jsem přihlášen jako \"#{username}\"")
end

Pokud("otevřu si svoje přání {string}") do |wish_title|
  step('jsem na stránce "Má přání"')
  step("kliknu na editaci u přání \"#{wish_title}\"")
end

Pokud("někdo z dárců u přání přidá příspěvek pro obdarované") do
  pending # Write code here that turns the phrase above into concrete actions
end

Pak("bych neměl mít možnost diskutovat") do
  step("neměl bych vidět text \"Diskuse\"")
end

Pak("můžu diskutovat") do
  step("měl bych vidět text \"Diskuse\"")
end
