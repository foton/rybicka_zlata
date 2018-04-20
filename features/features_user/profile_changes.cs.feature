# encoding: utf-8
# language: cs
Požadavek:  Nastavení profilu
  Jako registrovaný a přihlášený uživatel
  chci mít možnost změnit jméno a základní email
  abych ho měl vždy aktuální a dostával informace do správné schránky
Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem přihlášen jako "pepik"
  A přepnu na češtinu

Scénář: Změna emailu
  Když kliknu v menu na "Profil"
  A kliknu na editaci
  A změním "pepik@rybickazlata.cz" na "jezisek2@rybickazlata.cz"
  A kliknu na "Aktualizovat"

  Pak bych měl vidět "uživatel nebyl uložen kvůli chybě"
  A měl bych vidět "Aktuální heslo je povinná položka"

  Pokud zapíšu do položky "Aktuální heslo" text "Abcd1234"
  A kliknu na "Aktualizovat"

  Pak bych měl vidět "Úspěšně jste aktualizovali svůj účet, ale ještě musíte ověřit svou novou e-mailovou adresu."
  A měl bych vidět "Zkontrolujte prosím svou schránku a klikněte na odkaz pro dokončení ověření vaši nové e-mailové adresy."
  #email jezisek2 neni zatim potvrzeny, zustava puvodni
  A měl bych vidět "pepik@rybickazlata.cz "

  Pokud si otevřu poslední email pro adresu "jezisek2@rybickazlata.cz"
  A kliknu v emailu na odkaz "Potvrdit můj účet"

  Pak bych měl vidět "Váš účet byl úspěšně potvrzen."
  Pak bych se měl bez problémů přihlásit jako "jezisek2@rybickazlata.cz" s heslem "Abcd1234"

  A měl bych vidět "Hlavní e-mail: jezisek2@rybickazlata.cz"
  A neměl bych vidět "Hlavní e-mail: pepik@rybickazlata.cz "

Scénář: Změna jména
  Když kliknu v menu na "Profil"
  A kliknu na editaci
  A změním "pepik" na "Jozífek"
  A zapíšu do položky "Aktuální heslo" text "Abcd1234"
  A kliknu na "Aktualizovat"

  Pak bych měl vidět "Váš účet byl úspěšně aktualizován."
  A měl bych vidět "Jozífek"
  A neměl bych vidět "pepik" v nadpisech

Scénář: Doplnění rozšířených informací
  Když kliknu v menu na "Profil"
  A kliknu na editaci
  # běžné míry
  A zapíšu do položky "Výška [cm]" text "185"
  A zapíšu do položky "Váha [kg]" text "95"
  A zapíšu do položky "Velikost trička" text "XL"
  A zapíšu do položky "Velikost kalhot - pas" text "32"
  A zapíšu do položky "Velikost kalhot - délka" text "34"
  A zapíšu do položky "Velikost bot [EU]" text "45"
  # přesné míry
  A zapíšu do položky "Obvod hlavy [cm]" text "60"
  A zapíšu do položky "Dolní obvod krku [cm]" text "85"
  A zapíšu do položky "Obvod hrudníku přes prsa [cm]" text "185"
  A zapíšu do položky "Podprsenky - obvod pod prsy [cm]" text "165"
  A zapíšu do položky "Obvod v pase přes pupík [cm]" text "165"
  A zapíšu do položky "Obvod v bocích přes zadek [cm]" text "165"
  A zapíšu do položky "Délka mezi rameními švy zadem za krkem [cm]" text "165"
  A zapíšu do položky "Délka rukávu od ramenního švu po zápěstí [cm]" text "165"
  A zapíšu do položky "Délka košile/trička vzadu od krku dolů [cm]" text "165"
  A zapíšu do položky "Vnější délka nohavice od boku do konci nohavice [cm]" text "165"
  A zapíšu do položky "Délka vnitřního švu nohavice (od rozkroku ke konci nohavice) [cm]" text "165"
  A zapíšu do položky "Délka chodidla od paty po palec [cm]" text "165"

  A zapíšu do položky "Co se mi obecně líbí" text "barevné věci s neotřelým vzorem;  Queens, Neil Gaiman"

  A zapíšu do položky "Aktuální heslo" text "Abcd1234"
  A kliknu na "Aktualizovat"

  Pak bych měl vidět "Váš účet byl úspěšně aktualizován."
  A měl bych vidět "barevné věci s neotřelým vzorem; oranžová barva; steampunk; Queens, Neil Gaiman"

