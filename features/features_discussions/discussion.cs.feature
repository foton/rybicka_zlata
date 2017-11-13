# encoding: utf-8
# language: cs

Požadavek: Možnost diskutovat u konkrétního přání
  Jako přihlášený uživatel
  chci mít možnost u cizí přání příní diskutovat s ostatními dárci (či obdarovanými)
  abych splnil přání co nejlépe

Kontext:
  Pokud existují standardní testovací uživatelé

  Pokud u "Pepika" existuje kontakt "Kája" s adresou "karel@rybickazlata.cz"
  A u "Pepika" existuje kontakt "Charlie" s adresou "charles@rybickazlata.cz"
  A u "Karla" existuje kontakt "Josef" s adresou "pepik@rybickazlata.cz"
  A u "charlese" existuje kontakt "Pepa" s adresou "pepik@rybickazlata.cz"

  Pokud existuje přání "Pračka" uživatele "pepik"
  A to má dárce ["Charlie", "Kája"]
  # A má v obdarovaných ["Maruška"]

  A přepnu na češtinu

Scénář: Jako dárce můžu zahájit diskuzi
  Pokud jsem přihlášen jako "Karel"
  A otevřu si přání "Pračka" u "Josef"
  A kliknu na "Diskutovat"
  Pak bych měl vidět formulář na první příspěvek

  Pokud přidám příspěvek "komentář pro dárce"
  Pak bych měl vidět příspěvek "první komentář" od "Karel"

@javascript
Scénář: Jako dárce můžu nechat svůj příspěvek zobrazit i obdarovaným
  Pokud jsem přihlášen jako "Karel"
  A otevřu si přání "Pračka" u "Josef"
  A přidám příspěvek "komentář pro dárce"
  A přidám příspěvek "komentář pro obdarované" s označením "viditelné pro obdarované"
  Pak bych měl vidět příspěvek "komentář pro dárce" od "Karel"
  A měl bych vidět příspěvek "komentář pro obdarované" od "Karel"

  Pokud se přihlásím jako "charles"
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
  Pak můžu diskutovat
