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

@javascript
Scénář: Přidání kontaktu
  Pokud jsem na stránce "Kontakty"
  A otevřu si formulář pro přidání
  A zapíšu do položky "Jméno" text "Ježíšek"
  A zapíšu do položky "E-mail" text "jezisek@rybickazlata.cz"
  A kliknu na uložení
  Pak vidím text "Kontakt 'Ježíšek [???]: jezisek@rybickazlata.cz' byl úspěšně přidán."
  A v seznamu přátel je kontakt "Ježíšek" s adresou "jezisek@rybickazlata.cz"

@javascript
Scénář: Úprava přítele
  Pokud existuje přítel "Ježíšek [???]: jezisek@rybickazlata.cz"
  A jsem na stránce "Kontakty"
  A kliknu na editaci u "Ježíšek"

  Pak jsem na stránce editace kontaktu "Ježíšek"
  A změním "Ježíšek" na "Ježíšek2"
  A změním "jezisek@rybickazlata.cz" na "jezisek2@rybickazlata.cz"
  A kliknu na uložení

  Pak jsem na stránce "Kontakty"
  A vidím text "Kontakt 'Ježíšek2 [???]: jezisek2@rybickazlata.cz' byl úspěšně aktualizován."
  A v seznamu přátel je kontakt "Ježíšek2" s adresou "jezisek2@rybickazlata.cz"
  A v seznamu přátel není kontakt "Ježíšek" s adresou "jezisek@rybickazlata.cz"

@javascript
Scénář: Odstranění přítele
  Pokud existuje přítel "Ježíšek [???]: jezisek@rybickazlata.cz"
  A jsem na stránce "Kontakty"
  A kliknu na smazání u "Ježíšek"
  A smazání potvrdím

  Pak jsem na stránce "Kontakty"
  A vidím text "Kontakt 'Ježíšek [???]: jezisek@rybickazlata.cz' byl úspěšně smazán."
  A v seznamu přátel není kontakt "Ježíšek" s adresou "jezisek@rybickazlata.cz"

@javascript
Scénář: Zobrazení rozšířených informací
  Pokud existuje přítel "Ježíšek [???]: jezisek@rybickazlata.cz"
  A jsem na stránce "Kontakty"
  A kliknu na "rozšířené informace" u "Ježíšek"

  Pak jsem na stránce "Ježíšek"
  A vidím text "jeho rozšířené informaca"
