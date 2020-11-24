# encoding: utf-8
# language: cs

Požadavek: Správa kontaktů na mé známé
  Jako přihlášený uživatel
  chci mít možnost spravovat seznam kontaktů na přátele (potenciálních dárců a spoluobdarovaných)
  aby oni mohli vidět má přání nebo být moji spoluobdarovaní

Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem přihlášen jako "Bart"
  A přepnu na češtinu
  A existuje přítel "Milhouse [Milhouse Mussolini Van Houten]: milhouse@gmail.com"
  A jsem na stránce "Kontakty"

@javascript
Scénář: Přidání kontaktu
  Pokud si otevřu formulář pro přidání
  A zapíšu do položky "Jméno" text "Ježíšek"
  A zapíšu do položky "E-mail" text "jezisek@rybickazlata.cz"
  A kliknu na uložení

  Pak vidím text "Kontakt 'Ježíšek [???]: jezisek@rybickazlata.cz' byl úspěšně přidán."
  A v seznamu přátel je kontakt "Ježíšek" s adresou "jezisek@rybickazlata.cz"

@javascript
Scénář: Úprava přítele
  A kliknu na editaci u "Milhouse"

  Pak jsem na stránce editace kontaktu "Milhouse"
  A změním "Milhouse" na "Milhouse2"
  A změním "milhouse@gmail.com" na "milhouse@email.cz"
  A kliknu na uložení

  Pak jsem na stránce "Kontakty"
  A vidím text "Kontakt 'Milhouse2 [Milhouse Mussolini Van Houten]: milhouse@email.cz' byl úspěšně aktualizován."
  A v seznamu přátel je kontakt "Milhouse2" s adresou "milhouse@email.cz"
  A v seznamu přátel není kontakt "Milhouse" s adresou "milhouse@gmail.com"

@javascript
Scénář: Odstranění přítele
  Pokud kliknu na smazání u "Milhouse"
  A smazání potvrdím

  Pak jsem na stránce "Kontakty"
  A vidím text "Kontakt 'Milhouse [Milhouse Mussolini Van Houten]: milhouse@gmail.com' byl úspěšně smazán."
  A v seznamu přátel není kontakt "Milhouse" s adresou "milhouse@gmail.com"

@javascript
Scénář: Zobrazení rozšířených informací
  Pokud přidám přítele "Flanders [Ned]: ned.flanders@gmail.com"
  A ten má v oblibě "Marii a Josefa"
  A jsem na stránce "Profil"
  # reloading Kontakty
  A jsem na stránce "Kontakty"

  Pokud kliknu na "Ned"

  Pak jsem na info stránce pro "Ned"
  A vidím text "Mám rád(a): Marii a Josefa"
