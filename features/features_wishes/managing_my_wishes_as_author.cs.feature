# encoding: utf-8
# language: cs

Požadavek: Práce s přáními jako autor
  Jako přihlášený uživatel Bart
  chci mít možnost spravovat svá přání
  abych je mohl dostat to co opravdu chci

Kontext:
  Pokud existují standardní testovací uživatelé

  A jsem přihlášen jako "Bart"
  A přepnu na češtinu
  A jsem na stránce "Má přání"

@javascript
Scénář: Přidání přání
  Pokud kliknu na přidání
  A zapíšu do položky "Titulek nového přání" text "Kalhoty s kapsami"
  A zapíšu do položky "Širší popis" text "Ale velkými! Takové jako má Krteček. Třeba zde: http://img.csfd.cz/files/images/film/photos/157/911/157911911_df971a.jpg?w700"
  A do seznamu dárců přidám "Milhouse"
  A do seznamu dárců přidám "Family (without Maggie)"
  A kliknu na uložení

  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu

  Pak jsem na stránce přání "Kalhoty s kapsami"
  A vidím text "Přání 'Kalhoty s kapsami' bylo úspěšně přidáno."
  A vidím kontakt "Mom" v "Dárci"
  A vidím kontakt "Dad" v "Dárci"
  A vidím kontakt "Liiiisaaa" v "Dárci"
  A vidím kontakt "Milhouse" v "Dárci"
  A vidím kontakt "Autor přání [Bartholomew JoJo Simpson]" v "Obdarovaní"
  A můžu rovnou přidat další přání

  Pokud jsem na stránce "Má přání"
  A v seznamu přání je přání "Kalhoty s kapsami" se 1 potenciálními dárci

@javascript
Scénář: Přidání sdíleného přání
  Pokud kliknu na přidání
  A zapíšu do položky "Titulek nového přání" text "Pračka"
  A zapíšu do položky "Širší popis" text "Abychom nechodili špinaví"
  A do seznamu dárců přidám "Milhouse"
  A do seznamu dárců přidám "Family (without Maggie)"
  A do seznamu obdarovaných přidám "Meg"
  A kliknu na uložení
  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu

  Pak jsem na stránce přání "Pračka"
  A vidím text "Přání 'Pračka' bylo úspěšně přidáno."
  A vidím kontakt "Milhouse" v "Dárci"
  A vidím lidi ze skupiny "Family (without Maggie)" v "Dárci"

  A vidím kontakt "Autor přání [Bartholomew JoJo Simpson]" v "Obdarovaní"
  A vidím kontakt "Meg" v "Obdarovaní"

  Pokud jsem na stránce "Má přání"
  A v seznamu přání je přání "Pračka" se 1 potenciálními dárci

@javascript
Scénář: Úprava přání
  Pokud kliknu na editaci u přání "Bart wish (shown only to Homer)"

  Pak jsem na stránce editace přání "Bart wish (shown only to Homer)"
  A zapíšu do položky "Titulek přání" text "Bart wish (shown only to Lisa)"
  A zapíšu do položky "Širší popis" text "však víte ne"
  A do seznamu dárců přidám "Liiiisaaa"
  A ze seznamu dárců odeberu "Dad"
  A kliknu na uložení

  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu

  Pak jsem na stránce přání "Bart wish (shown only to Lisa)"
  A vidím text "Přání 'Bart wish (shown only to Lisa)' bylo úspěšně aktualizováno."
  A nevidím kontakt "Dad" v "Dárci"
  A vidím kontakt "Liiiisaaa" v "Dárci"


@javascript
Scénář: Úprava sdíleného přání
  Pokud kliknu na editaci u přání "B+H: New sport car"

  Pak jsem na stránce editace přání "B+H: New sport car"
  A zapíšu do položky "Titulek přání" text "B+MILH: Bus"
  A zapíšu do položky "Širší popis" text "co neposkakuje"
  A do seznamu dárců přidám "Meg"
  A ze seznamu dárců odeberu "Liiiisaaa"
  A do seznamu obdarovaných přidám "Milhouse"
  A ze seznamu obdarovaných odeberu "Dad"
  A kliknu na uložení

  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu

  Pak jsem na stránce přání "B+MILH: Bus"
  A vidím text "Přání 'B+MILH: Bus' bylo úspěšně aktualizováno."
  A nevidím kontakt "Liiiisaaa" v "Dárci"
  A vidím kontakt "Meg" v "Dárci"
  A nevidím kontakt "Dad" v "Obdarovaní"
  A vidím kontakt "Milhouse" v "Obdarovaní"

@javascript
Scénář: Smazání přání
  Pokud kliknu na smazání u přání "B: New faster skateboard"
  A smazání potvrdím

  Pak jsem na stránce "Má přání"
  A vidím text "Přání 'B: New faster skateboard' bylo úspěšně smazáno."
  A v seznamu přání není přání "B: New faster skateboard"

@javascript
Scénář: Smazání sdíleného přání
  Pokud kliknu na smazání u přání "B+H: New sport car"
  A smazání potvrdím

  Pak jsem na stránce "Má přání"
  A vidím text "Přání 'B+H: New sport car' bylo úspěšně smazáno."
  A v seznamu přání není přání "B+H: New sport car"

@javascript
Scénář: Vyřazení/Splnění přání
  Pokud kliknu na splnění u přání "B: New faster skateboard"

  Pak jsem na stránce "Má přání"
  A vidím text "Přání 'B: New faster skateboard' bylo splněno"
  A v seznamu přání není přání "B: New faster skateboard"

  Pokud jdu na stránku "Vyřazená přání"
  Pak v seznamu přání je přání "B: New faster skateboard"




