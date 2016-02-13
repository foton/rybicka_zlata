# encoding: utf-8
# language: cs

Požadavek: Práce s přáními
  Jako přihlášený uživatel 
  chci mít možnost spravovat svá přání
  abych je mohl dostat to co opravdu chci

Kontext:
  Pokud existují standardní testovací uživatelé
  A u "pepika" existuje konexe "Karel"
  A u "pepika" existuje konexe "Mařenka" s adresou "marenka@rybickazlata.cz"
  A u "pepika" existuje skupina "Kámoši" se členy ["Hynek", "Vilda","Jarka"]
  A u "pepika" existuje skupina "Rodina" se členy ["Máma", "Táta" , "Mařenka"]

  A u "Mařenky" existuje konexe "Karel"
  A u "Mařenky" existuje konexe "Jana"
  A u "Mařenky" existuje konexe "Pepík" s adresou "pepik@rybickazlata.cz"
  A u "Mařenky" existuje skupina "Kámarádi" se členy ["Tom", "Bob"]
  A u "Mařenky" existuje skupina "Rodina" se členy ["Máma", "Táta", "Pepík"]

  A jsem přihlášen jako "pepik"
  A přepnu na češtinu  


Scénář: Přidání přání
  Pokud jsem na stránce "Má přání"
  A otevřu si formulář pro přidání
  A zapíšu do položky "Název" text "Kalhoty s kapsami"
  A zapíšu do položky "Popis" text "Ale velkými! Tkaové jako má Krteček. Třeba zde: http://img.csfd.cz/files/images/film/photos/157/911/157911911_df971a.jpg?w700"
  A kliknu na pokračování

  Pak jsem na stránce editace přání "Kalhoty s kapsami"
  A vidím text "Přání 'Kalhoty s kapsami' bylo úspěšně přidáno. Nyní určete kdo bude mít možnost ho vidět. A v případě sdíleného přání vyberte i spoluobdarované."
  A do seznamu přidám "Rodina"
  A do seznamu přidám "Karel"
  A kliknu na uložení

  Pak jsem na stránce "Přání 'Kalhoty s kapsami'"
  A vidím text "Přání 'Kalhoty s kapsami' bylo úspěšně nastaveno."
  A vidím konexi "Máma"
  A vidím konexi "Táta"
  A vidím konexi "Mařenka"
  A vidím konexi "Karel"

  Pokud jsem na stránce "Má přání" 
  A v seznamu přání je přání "Kalhoty s kapsami" se 4 potenciálními dárci

# Scénář: Přidání sdíleného přání

# Scénář: Úprava přání
# Scénář: Úprava sdíleného přání

# Scénář: Smazání přání
# Scénář: Smazání sdíleného přání

# Scénář: Vyřazení přání
# Scénář: Vyřazení sdíleného přání





