# encoding: utf-8
# language: cs
Požadavek:  Registrace do aplikace
  Jako neregistrovaný a nepřihlášený uživatel
  se chci zaregistrovat
  abych se mohl následně přihlásit a používat Rybičku

Scénář: Registrace uživatele jen přes aplikaci
  Pokud jsem na úvodní stránce
  Když kliknu na odkaz "Registrace"
  A zapíšu do položky "E-mail" text "prvni@rybickazlata.cz"
  #A ukaž mi stránku
  A zapíšu do položky "Heslo" text "NeznáméHeslo328"
  A zapíšu do položky "Heslo pro kontrolu" text "NeznáméHeslo328"
  A vyberu "Čeština" z nabídky "Jazyk"
  A vyberu "(GMT+01:00) Prague" z nabídky "Časové pásmo"
  A kliknu na "Zaregistrovat"

  Pak bych měl vidět "Vítejte! Registrace byla úspěšná."
  A měl bych být úspěšně přihlášen jako "prvni@rybickazlata.cz"
