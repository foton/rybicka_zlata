# encoding: utf-8
# language: cs

Požadavek: Práce s přáními jako obdarovaný
  Jako přihlášený uživatel Mařenka
  chci mít možnost spravovat svá (či cizí ale sdílená) přání
  abych je mohl dostat to co opravdu chci

Kontext:
  Pokud existují standardní testovací uživatelé
  A u "pepika" existuje konexe "Karel"
  A u "pepika" existuje konexe "Mařenka" s adresou "marenka@rybickazlata.cz"
  A u "pepika" existuje skupina "Kámoši" se členy ["Hynek", "Vilda","Jarka"]
  A u "pepika" existuje skupina "Rodina" se členy ["Máma", "Táta" , "Mařenka"]

  A u "Mařenky" existuje konexe "KarelM"
  A u "Mařenky" existuje konexe "Jana"
  A u "Mařenky" existuje konexe "Hana"
  A u "Mařenky" existuje konexe "Pepík" s adresou "pepik@rybickazlata.cz"
  A u "Mařenky" existuje skupina "Kámarádi" se členy ["Tom", "Bob"]
  A u "Mařenky" existuje skupina "Rodina" se členy ["Máma", "Táta", "Pepík"]

  A "Mařenka" má kontakt "maruska@example.com"
  
  A přepnu na češtinu  

  Pokud existuje přání "Pračka" uživatele "pepik"
  A to má dárce ["Máma", "Táta"]
  A má v obdarovaných ["Maruška"]
  
  A jsem přihlášen jako "Mařenka"

@javascript
Scénář: Úprava sdíleného přání
  Pokud jsem na stránce "Má přání"
  A kliknu na editaci u přání "Pračka"

  Pak jsem na stránce editace přání "Pračka"
  A do seznamu dárců přidám "Jana"
  A do seznamu dárců přidám "KarelM"
  A kliknu na uložení
  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu 

  Pak jsem na stránce přání "Pračka"
  A vidím text "Seznam potenciálních dárců pro 'Pračka' byl úspěšně aktualizován."
  A vidím konexi "Jana" v "Dárci"
  A vidím konexi "KarelM" v "Dárci"
  A vidím konexi "Autor přání [pepik]" v "Obdarovaní"
  A vidím konexi "Maruška [Mařenka]" v "Obdarovaní"

  Pokud kliknu na editaci

  Pak jsem na stránce editace přání "Pračka"
  A ze seznamu dárců odeberu "Jana"
  A do seznamu dárců přidám "Hana"
  A kliknu na uložení
  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu 

  Pak jsem na stránce přání "Pračka"
  A vidím text "Seznam potenciálních dárců pro 'Pračka' byl úspěšně aktualizován."
  A nevidím konexi "Jana" v "Dárci"
  A vidím konexi "Hana" v "Dárci"
  A vidím konexi "KarelM" v "Dárci"
  
@javascript
Scénář: Smazání sdíleného přání
  Pokud jsem na stránce "Má přání"
  A kliknu na smazání u přání "Pračka"
  A smazání potvrdím

  Pak jsem na stránce "Má přání"
  A vidím text "Byli jste odebráni z obdarovaných u přání 'Pračka'."
  A v seznamu přání není přání "Pračka"

# Scénář: Vyřazení přání
# Scénář: Vyřazení sdíleného přání





