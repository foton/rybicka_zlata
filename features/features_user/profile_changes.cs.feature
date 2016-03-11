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
