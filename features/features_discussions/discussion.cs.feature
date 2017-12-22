# encoding: utf-8
# language: cs

Požadavek: Možnost diskutovat u konkrétního přání
  Jako přihlášený uživatel
  chci mít možnost u cizí přání příní diskutovat s ostatními dárci (či obdarovanými)
  abych splnil přání co nejlépe

Kontext:
  Pokud existují standardní testovací uživatelé

  Pokud u "Pepika" existuje kontakt "Kája" s adresou "karel@rybickazlata.cz"
  A u "Pepika" existuje kontakt "Mojmír" s adresou "mojmir@rybickazlata.cz"
  A u "Karla" existuje kontakt "Josef" s adresou "pepik@rybickazlata.cz"
  A u "Mojmíra" existuje kontakt "Pepa" s adresou "pepik@rybickazlata.cz"

  Pokud existuje přání "Pračka" uživatele "pepik"
  A to má dárce ["Mojmír", "Kája"]
  # A má v obdarovaných ["Maruška"]

  A přepnu na češtinu

Scénář: Jako dárce můžu zahájit diskuzi
  Pokud jsem přihlášen jako "Karel"
  A otevřu si přání "Pračka" u "Josef"
  Pak bych měl vidět formulář na první příspěvek

  Pokud přidám příspěvek "komentář pro dárce"
  Pak bych měl vidět příspěvek "komentář pro dárce" od "Karel"

Scénář: Jako dárce můžu nechat svůj příspěvek zobrazit i obdarovaným
  Pokud jsem přihlášen jako "Karel"
  A otevřu si přání "Pračka" u "Josef"
  A přidám příspěvek "komentář pro dárce"
  A přidám příspěvek "komentář pro obdarované" s označením "Zobrazit i obdarovaným"
  Pak bych měl vidět příspěvek "komentář pro dárce" od "Karel"
  A měl bych vidět příspěvek "komentář pro obdarované" od "Karel"

  Pokud se přihlásím jako "Mojmír"
  A otevřu si přání "Pračka" u "Pepa"
  Pak bych měl vidět příspěvek "komentář pro dárce" od "Karel"
  A měl bych vidět příspěvek "komentář pro obdarované" od "Karel"

  Pokud se přihlásím jako "pepik"
  A otevřu si svoje přání "Pračka"
  Pak bych neměl vidět příspěvek "komentář pro dárce" od "Karel"
  A měl bych vidět příspěvek "komentář pro obdarované" od "Karel"

Scénář: Jako obdarovaný můžu reagovat na příspěvek z diskuze
  Pokud se přihlásím jako "pepik"
  A otevřu si svoje přání "Pračka"
  Pak bych neměl mít možnost diskutovat

  Pokud někdo z dárců u přání přidá příspěvek pro obdarované
  A otevřu si svoje přání "Pračka"
  Pak můžu diskutovat

Scénář: Můžu smazat svůj poslední příspěvek, pokud je poslední v řadě
  Pokud jsem přihlášen jako "Karel"
  A otevřu si přání "Pračka" u "Josef"
  A přidám příspěvek "komentář pro dárce"
  A přidám příspěvek "komentář pro obdarované" s označením "Zobrazit i obdarovaným"
  Pak bych měl vidět příspěvek "komentář pro dárce" od "Karel"
  A měl bych vidět příspěvek "komentář pro obdarované" od "Karel"
  A můžu smazat příspěvek "komentář pro obdarované" od "Karel"
  A můžu smazat příspěvek "komentář pro dárce" od "Karel"

  Pokud přidám příspěvek "druhý komentář pro dárce"
  A někdo jiný přidá svůj příspěvek
  Pak už nemůžu smazat příspěvek "druhý komentář pro dárce" od "Karel"

