# encoding: utf-8
# language: cs

Požadavek: Práce s přáními jako obdarovaný
  Jako přihlášený uživatel Bart
  chci mít možnost spravovat svá (či cizí ale sdílená) přání
  abych je mohl dostat to co opravdu chci

Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem přihlášen jako "Bart"
  A přepnu na češtinu
  A jsem na stránce "Má přání"

@javascript
Scénář: Úprava sdíleného přání
  Pokud kliknu na editaci u přání "L+B: Bigger family car"

  Pak jsem na stránce editace přání "L+B: Bigger family car"
  A vidím kontakt "Dad" v "Dárci"

  Pokud ze seznamu dárců odeberu "Dad"
  A do seznamu dárců přidám "Meg"
  # donee can not change donees or wish attributes, only donors
  A kliknu na uložení

  # without this the (next) next step is done before wish is saved
  A počkám si 1 vteřinu

  Pak jsem na stránce přání "L+B: Bigger family car"
  A vidím text "Seznam potenciálních dárců pro 'L+B: Bigger family car' byl úspěšně aktualizován."
  A nevidím kontakt "Dad" v "Dárci"
  A vidím kontakt "Meg" v "Dárci"
  A vidím kontakt "Autor přání [Lisa Marie Simpson]" v "Obdarovaní"
  A vidím kontakt "Misfit [Bartholomew JoJo Simpson]" v "Obdarovaní"

@javascript
Scénář: Smazání sdíleného přání
  A kliknu na smazání u přání "L+B: Bigger family car"
  A smazání potvrdím

  Pak jsem na stránce "Má přání"
  A vidím text "Byli jste odebráni z obdarovaných u přání 'L+B: Bigger family car'."
  A v seznamu přání není přání "L+B: Bigger family car"

@javascript
Scénář: Vyřazení/Splnění sdíleného přání
  A kliknu na splnění u přání "L+B: Bigger family car"

  Pak jsem na stránce "Má přání"
  A vidím text "Přání 'L+B: Bigger family car' bylo splněno"
  A v seznamu přání není přání "L+B: Bigger family car"

  Pokud jdu na stránku "Vyřazená přání"
  Pak v seznamu přání je přání "L+B: Bigger family car"





