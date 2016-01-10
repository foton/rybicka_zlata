# encoding: utf-8
# language: cs

Požadavek: Správa kontaktů na mé známé
  Jako přihlášený uživatel
  chci mít možnost spravovat seznam kontaktů na přátele (potenciálních dárců a spoluobdarovaných)
  aby oni mohli vidět má přání nebo být moji spoluobdarovaní

Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem přihlášen jako "pepik"
  A přepnu na češtinu  
  A jsem na stránce "Lidé"

Scénář: Přidání kontaktu
  Pokud kliknu na "+"
  A zapíšu do položky "Název kontaktu" text "Ježíšek"
  A zapíšu do položky "Kontaktní adresa" text "jezisek@rybickazlata.cz"
  A kliknu na "Přidat"
  Pak vidím text "Kontakt 'Ježíšek' byl úspešně přidán."
  A v seznamu lidí je "Ježíšek" s adresou "jezisek@rybickazlata.cz"

Scénář: Úprava kontaktu
  Pokud existuje kontakt "Ježíšek [jezisek@rybickazlata.cz]"
  A kliknu na editaci u "Ježíšek"

  Pak jsem na stránce editace kontaktu "Ježíšek"
  A změním "Ježíšek" na "Ježíšek2"
  A změním "jezisek@rybickazlata.cz" na "jezisek2@rybickazlata.cz"
  A kliknu na "Uložit"

  Pak jsem na stránce "Lidé"
  A vidím text "Kontakt 'Ježíšek2' byl aktualizován."
  A v seznamu lidí je kontakt "Ježíšek2 [jezisek2@rybickazlata.cz]"
  A v seznamu lidí není kontakt "Ježíšek [jezisek@rybickazlata.cz]"

Scénář: Odstranění kontaktu
  Pokud existuje kontakt "Ježíšek [jezisek@rybickazlata.cz]"
  A kliknu na smazání u "Ježíšek"
  A smazání potvrdím
  
  Pak jsem na stránce "Lidé"
  A vidím text "Kontakt 'Ježíšek' byl úspešně smazán."
  A v seznamu lidí není kontakt "Ježíšek [jezisek@rybickazlata.cz]"

