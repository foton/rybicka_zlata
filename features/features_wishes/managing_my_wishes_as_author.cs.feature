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

@javascript
Scénář: Přidání přání
  Pokud jsem na stránce "Má přání"
  A kliknu na přidání
  A zapíšu do položky "Titulek nového přání" text "Kalhoty s kapsami"
  A zapíšu do položky "Širší popis" text "Ale velkými! Takové jako má Krteček. Třeba zde: http://img.csfd.cz/files/images/film/photos/157/911/157911911_df971a.jpg?w700"
  A do seznamu dárců přidám "Karel"
  #TODO: groups are not yet ready A do seznamu dárců přidám "Rodina"
  A kliknu na uložení
  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu 

  Pak jsem na stránce přání "Kalhoty s kapsami"
  A vidím text "Přání 'Kalhoty s kapsami' bylo úspěšně přidáno."
  #A vidím konexi "Máma" v "Dárci"
  #A vidím konexi "Táta" v "Dárci"
  #A vidím konexi "Mařenka" v "Dárci"
  A vidím konexi "Karel" v "Dárci"
  A vidím konexi "Autor přání [pepik]" v "Obdarovaní"


  Pokud jsem na stránce "Má přání" 
  A v seznamu přání je přání "Kalhoty s kapsami" se 1 potenciálními dárci

@javascript
Scénář: Přidání sdíleného přání
  Pokud jsem na stránce "Má přání"
  A kliknu na přidání
  A zapíšu do položky "Titulek nového přání" text "Pračka"
  A zapíšu do položky "Širší popis" text "Abychom nechodili špinaví"
  A do seznamu dárců přidám "Karel"
  A do seznamu dárců přidám "Máma"
  A do seznamu dárců přidám "Táta"
  #TODO: groups are not yet ready A do seznamu dárců přidám "Kámoši"
  A do seznamu obdarovaných přidám "Mařenka"
  A kliknu na uložení
  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu 

  Pak jsem na stránce přání "Pračka"
  A vidím text "Přání 'Pračka' bylo úspěšně přidáno."
  A vidím konexi "Máma" v "Dárci"
  A vidím konexi "Táta" v "Dárci"
  A vidím konexi "Karel" v "Dárci"
 #A vidím lidi ze skupiny "Kámoši" v Dárci
  
  A vidím konexi "Autor přání [pepik]" v "Obdarovaní"
  A vidím konexi "Mařenka" v "Obdarovaní"

  Pokud jsem na stránce "Má přání" 
  A v seznamu přání je přání "Pračka" se 1 potenciálními dárci

@javascript
Scénář: Úprava přání
  Pokud existuje moje přání "Kalhoty s kapsami"
  A to má dárce ["Máma", "Táta"]

  Pokud jsem na stránce "Má přání"
  A kliknu na editaci u přání "Kalhoty s kapsami"

  Pak jsem na stránce editace přání "Kalhoty s kapsami"
  A zapíšu do položky "Titulek přání" text "Kalhoty s velkými kapsami"
  A zapíšu do položky "Širší popis" text "však víte ne"
  A do seznamu dárců přidám "Karel"
  A ze seznamu dárců odeberu "Máma"
  A kliknu na uložení
  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu 

  Pak jsem na stránce přání "Kalhoty s velkými kapsami"
  A vidím text "Přání 'Kalhoty s velkými kapsami' bylo úspěšně aktualizováno."
  A nevidím konexi "Máma" v "Dárci"
  A vidím konexi "Táta" v "Dárci"
  A vidím konexi "Karel" v "Dárci"


@javascript
Scénář: Úprava sdíleného přání
  Pokud existuje moje přání "Pračka"
  A to má dárce ["Máma", "Táta"]
  A má v obdarovaných ["Maruška"]
  
  Pokud jsem na stránce "Má přání"
  A kliknu na editaci u přání "Pračka"

  Pak jsem na stránce editace přání "Pračka"
  A zapíšu do položky "Titulek přání" text "Automatická pračka"
  A zapíšu do položky "Širší popis" text "co neposkakuje"
  A do seznamu dárců přidám "Karel"
  A ze seznamu dárců odeberu "Máma"
  A do seznamu obdarovaných přidám "Máma"
  A ze seznamu obdarovaných odeberu "Maruška"
  A kliknu na uložení
  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu 

  Pak jsem na stránce přání "Automatická pračka"
  A vidím text "Přání 'Automatická pračka' bylo úspěšně aktualizováno."
  A nevidím konexi "Máma" v "Dárci"
  A vidím konexi "Táta" v "Dárci"
  A vidím konexi "Karel" v "Dárci"
  A nevidím konexi "Maruška" v "Obdarovaní"
  A vidím konexi "Máma" v "Obdarovaní"

Scénář: Smazání přání
  Pokud existuje moje přání "Kalhoty s kapsami"
  A to má dárce ["Máma", "Táta"]

  Pokud jsem na stránce "Má přání"
  A kliknu na smazání u přání "Kalhoty s kapsami"

  Pak jsem na stránce "Má přání"
  A vidím text "Přání 'Kalhoty s kapsami' bylo úspěšně smazáno."
  A v seznamu přání není přání "Kalhoty s kapsami"

Scénář: Smazání sdíleného přání
  Pokud existuje moje přání "Pračka"
  A to má dárce ["Máma", "Táta"]
  A má v obdarovaných ["Maruška"]
  
  Pokud jsem na stránce "Má přání"
  A kliknu na smazání u přání "Pračka"

  Pak jsem na stránce "Má přání"
  A vidím text "Přání 'Pračka' bylo úspěšně smazáno."
  A v seznamu přání není přání "Pračka"

# Scénář: Vyřazení přání
# Scénář: Vyřazení sdíleného přání





