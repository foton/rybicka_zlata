# encoding: utf-8
# language: cs

Požadavek:  Nastavení profilu
  Jako registrovaný a přihlášený uživatel
  chci mít možnost změnit jméno a základní email
  abych ho měl vždy aktuální a dostával informace do správné schránky

Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem přihlášen jako "bart"
  A přepnu na češtinu

Scénář: Změna emailu
  Když kliknu v menu na "Profil"
  A kliknu na editaci
  A změním "bart@simpsons.com" na "jezisek2@rybickazlata.cz"
  A kliknu na "Aktualizovat"

  Pak bych měl vidět "uživatel nebyl uložen kvůli chybě"
  A měl bych vidět "Aktuální heslo je povinná položka"

  Pokud zapíšu do položky "Aktuální heslo" text "Abcd1234"
  A kliknu na "Aktualizovat"

  Pak bych měl vidět "Úspěšně jste aktualizovali svůj účet, ale ještě musíte ověřit svou novou e-mailovou adresu."
  A měl bych vidět "Zkontrolujte prosím svou schránku a klikněte na odkaz pro dokončení ověření vaši nové e-mailové adresy."
  # email jezisek2 neni zatim potvrzeny, zustava puvodni
  A měl bych vidět "bart@simpsons.com"

  Pokud si otevřu poslední email pro adresu "jezisek2@rybickazlata.cz"
  A kliknu v emailu na odkaz "Potvrdit můj účet"

  Pak bych měl vidět "Váš účet byl úspěšně potvrzen."
  Pak bych se měl bez problémů přihlásit jako "jezisek2@rybickazlata.cz" s heslem "Abcd1234"

  A měl bych vidět "Hlavní e-mail: jezisek2@rybickazlata.cz"
  A neměl bych vidět "Hlavní e-mail: bart@simpsons.com"

Scénář: Změna jména
  Když kliknu v menu na "Profil"
  A kliknu na editaci
  A změním "Bartholomew JoJo Simpson" na "Jozífek"
  A zapíšu do položky "Aktuální heslo" text "Abcd1234"
  A kliknu na "Aktualizovat"

  Pak bych měl vidět "Váš účet byl úspěšně aktualizován."
  A měl bych vidět "Jozífek"
  A neměl bych vidět "Bartholomew" v nadpisech

Scénář: Doplnění rozšířených informací
  Když kliknu v menu na "Profil"
  A kliknu na editaci
  # běžné míry
  A zapíšu do položky "Výška" text "185cm"
  A zapíšu do položky "Váha" text "95kg"
  A zapíšu do položky "Velikost trička" text "XL"
  A zapíšu do položky "Kalhoty - šířka v pase" text "32"
  A zapíšu do položky "Kalhoty - délka nohavice" text "34"
  A zapíšu do položky "Velikost bot [EU/UK/US]" text "45"
  # přesné míry
  A doplním podrobnější info do položky "Další míry"

  A zapíšu do položky "Mám rád(a)" text "barevné věci s neotřelým vzorem; oranžová barva; steampunk; Queens, Neil Gaiman"
  A zapíšu do položky "Nemám rád(a)" text "černé oblečení"

  A zapíšu do položky "Aktuální heslo" text "Abcd1234"
  A kliknu na "Aktualizovat"

  Pak bych měl vidět "Váš účet byl úspěšně aktualizován."
  A měl bych vidět "185cm"
  A měl bych vidět "95kg"
  A měl bych vidět "barevné věci s neotřelým vzorem; oranžová barva; steampunk; Queens, Neil Gaiman"

