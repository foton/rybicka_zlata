# encoding: utf-8
# language: cs

Požadavek:  Registrace do aplikace
  Jako neregistrovaný a nepřihlášený uživatel
  se chci zaregistrovat
  abych se mohl následně přihlásit a používat Rybičku
Kontext:
  Pokud jsem na úvodní stránce
  A přepnu na češtinu

Scénář: Registrace uživatele jen přes aplikaci
  Když kliknu v menu na "Registrovat"
  A zapíšu do položky "Hlavní e-mail" text "prvni@rybickazlata.cz"
  A zapíšu do položky "Heslo" text "NeznáméHeslo328"
  A zapíšu do položky "Potvrzení hesla" text "NeznáméHeslo328"
  A vyberu "Čeština" z nabídky "Jazyk"
  A vyberu "(GMT+01:00) Prague" z nabídky "Časové pásmo"
  A kliknu na tlačítko "Registrovat"

  Pak bych měl vidět "Vítejte! Registrace byla úspěšná."
  A měl bych vidět "Pro dokončení otevřete aktivační odkaz zaslaný na váš email."

  Pokud si otevřu poslední email pro adresu "prvni@rybickazlata.cz"
  A kliknu v emailu na odkaz "Potvrdit můj účet"

  Pak bych měl vidět "Váš účet byl úspěšně potvrzen."
  Pak bych se měl bez problémů přihlásit jako "prvni@rybickazlata.cz" s heslem "NeznáméHeslo328"

#Scénář: Registrace uživatele přes Google+
#  Když kliknu na odkaz "Registrace"
#  A kliknu na "Google+"
#
#  Pak bych měl vidět "Úspěšná autorizace z účtu Google."
#  A měl bych být přihlášen

#Scénář: Registrace uživatele přes Github
#  Když kliknu na odkaz "Registrace"
#  A kliknu na "GitHub"
#
#  Pak bych měl vidět "Úspěšná autorizace z účtu GithHub."
#  A měl bych být přihlášen
