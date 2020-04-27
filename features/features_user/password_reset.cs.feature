# encoding: utf-8
# language: cs

Požadavek:  Registrace do aplikace
  Jako registrovaný a nepřihlášený uživatel s děravou hlavou
  chci mít možnost resetu hesla
  abych se mohl následně přihlásit a používat Rybičku
Kontext:
  Pokud existují standardní testovací uživatelé
  A přepnu na češtinu

Scénář: Reset hesla
  Pokud jsem na úvodní stránce
  Když kliknu v menu na "Přihlásit"
  A kliknu na "Zapomněli jste heslo?"

  A zapíšu do položky "Hlavní e-mail" text "bart@simpsons.com"
  A kliknu na tlačítko "Poslat instrukce pro obnovení hesla"

  Pak bych měl vidět "Za několik minut obdržíte email s instrukcemi pro nastavení nového hesla."

  Pokud si otevřu poslední email pro adresu "bart@simpsons.com"
  A kliknu v emailu na odkaz "Změnit mé heslo"

  Pak bych měl vidět "Změna Vašeho hesla"
  A zapíšu do položky "Nové heslo" text "NeznáméHeslo328"
  A zapíšu do položky "Potvrdit nové heslo" text "NeznáméHeslo328"
  A kliknu na tlačítko "Změnit mé heslo"

  Pak bych měl vidět "Vaše heslo bylo úspěšně změněno. Nyní jste přihlášeni."

  Když se odhlásím
  Pak bych se měl bez problémů přihlásit jako "bart@simpsons.com" s heslem "NeznáméHeslo328"

