# encoding: utf-8
# language: cs
Požadavek: Operace s vlastními kontakty
  Jako přihlášený uživatel
  chci měnit seznam kontaktů na mě
  aby mě uživatelé mohli najít podle kontaktu, který oni znají

Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem přihlášen jako "bart@simpsons.com"
  A přepnu na češtinu

Scénář: Přidání kontaktu
  Když jsem na mé profilové stránce
  A otevřu si formulář pro přidání
  A zadám další adresu "cucky.pracky@kotrmelci.cz"
  A kliknu na uložení
  Pak je v seznamu mých e-mailových adres vidět i "cucky.pracky@kotrmelci.cz"
  A vidím text "Kontakt 'cucky.pracky@kotrmelci.cz' byl přidán"

@javascript
Scénář: Smazání kontaktu
  Pokud mám mezi kontakty adresu "basama@fousama.cz"
  A jsem na mé profilové stránce
  A kliknu na smazání u "basama@fousama.cz"
  A smazání potvrdím
  Pak v seznamu kontaktů už není adresa "basama@fousama.cz"
  A vidím text "Kontakt 'basama@fousama.cz' byl smazán"
  A uživatelům, kteří ji používali o tom přijde e-mail
