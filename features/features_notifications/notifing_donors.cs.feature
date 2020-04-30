# encoding: utf-8
# language: cs

Požadavek: Notofikace o změnách v přáních pro dárce
Jako přihlášený uživatel Karel
chci vidět, jaká cizí přání se změnila
abych měl rychle přehled

Kontext:
  Pokud existují standardní testovací uživatelé

  A u "pepika" existuje kontakt "Karel"
  A u "pepika" existuje kontakt "Mařenka"
  A u "Mařenky" existuje kontakt "Karel"
  A u "Mařenky" existuje kontakt "pepik"
  A u "Karla" existuje kontakt "pepik"
  A u "Karla" existuje kontakt "Mařenka"

  Pokud existuje přání "Dovolená v Karibiku" uživatele "pepik"
  A to má dárce ["Karel"]
  A má v obdarovaných ["Maruška"]

  A přepnu na češtinu
  A jsem přihlášen jako "Karel"

Scénář: Dostávám notifikace o změně
  Pokud jsem na stránce "Notifikace"
  Pak bych neměl vidět žádnou notifikaci k přání "Dovolená v Karibiku"

  Pokud "pepik" změní přání "Dovolená v Karibiku"
  A já si otevřu stránku "Notifikace"
  Pak bych měl vidět notifikaci "pepik změnil Dovolená v karibiku"
  # Notifications to User (107) 1\nOpen\nSomeone notified you of Wish (18) Feb 04 15:45
