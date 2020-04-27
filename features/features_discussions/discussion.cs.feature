# encoding: utf-8
# language: cs

Požadavek: Možnost diskutovat u konkrétního přání
  Jako přihlášený uživatel
  chci mít možnost u cizí přání příní diskutovat s ostatními dárci (či obdarovanými)
  abych splnil přání co nejlépe

Kontext:
  Pokud existují standardní testovací uživatelé

  Pokud u "Lízy" existuje kontakt "Mom" s adresou "marge@simpsons.com"
  A u "Barta" existuje kontakt "Dad" s adresou "homer@simpsons.com"
  A u "Homera" existuje kontakt "MiniMe" s adresou "bart@simpsons.com"
  A u "Marge" existuje kontakt "Son" s adresou "bart@simpsons.com"

  Pokud existuje přání "L+B: Bigger family car" uživatele "Líza"
  A má v obdarovaných ["Bart"]
  A to má dárce { "Líza" => ["Dad", "Mom"], "Bart" => ["Dad"] }

  A přepnu na češtinu

Scénář: Jako dárce můžu zahájit diskuzi
  Pokud jsem přihlášen jako "Homer"
  A otevřu si přání "L+B: Bigger family car" u "Bart"
  Pak bych měl vidět formulář na první příspěvek

  Pokud přidám příspěvek "komentář pro dárce"
  Pak bych měl vidět příspěvek "komentář pro dárce" od "Homer"

Scénář: Jako dárce můžu nechat svůj příspěvek zobrazit i obdarovaným
  Pokud jsem přihlášen jako "Homer"
  A otevřu si přání "L+B: Bigger family car" u "MiniMe"
  A přidám příspěvek "komentář pro dárce"
  A přidám příspěvek "komentář pro obdarované" s označením "Zobrazit i obdarovaným"
  Pak bych měl vidět příspěvek "komentář pro dárce" od "Homer"
  A měl bych vidět příspěvek "komentář pro obdarované" od "Homer"

  Pokud se přihlásím jako "Marge"
  A otevřu si přání "L+B: Bigger family car" u "Daughter"
  Pak bych měl vidět příspěvek "komentář pro dárce" od "Homer"
  A měl bych vidět příspěvek "komentář pro obdarované" od "Homer"

  Pokud se přihlásím jako "Lisa"
  A otevřu si svoje přání "L+B: Bigger family car"
  Pak bych neměl vidět příspěvek "komentář pro dárce" od "Homer"
  A měl bych vidět příspěvek "komentář pro obdarované" od "Homer"

Scénář: Jako obdarovaný můžu reagovat na příspěvek z diskuze
  Pokud se přihlásím jako "Bart"
  A otevřu si svoje přání "L+B: Bigger family car"
  Pak bych neměl mít možnost diskutovat

  Pokud někdo z dárců u přání přidá příspěvek pro obdarované
  A otevřu si svoje přání "L+B: Bigger family car"
  Pak můžu diskutovat

Scénář: Můžu smazat svůj poslední příspěvek, pokud je poslední v řadě
  Pokud jsem přihlášen jako "Homer"
  A otevřu si přání "L+B: Bigger family car" u "Bart"
  A přidám příspěvek "komentář pro dárce"
  A přidám příspěvek "komentář pro obdarované" s označením "Zobrazit i obdarovaným"
  Pak bych měl vidět příspěvek "komentář pro dárce" od "Homer"
  A měl bych vidět příspěvek "komentář pro obdarované" od "Homer"
  A můžu smazat příspěvek "komentář pro obdarované" od "Homer"
  A můžu smazat příspěvek "komentář pro dárce" od "Homer"

  Pokud přidám příspěvek "druhý komentář pro dárce"
  A někdo jiný přidá svůj příspěvek
  Pak už nemůžu smazat příspěvek "druhý komentář pro dárce" od "Homer"
