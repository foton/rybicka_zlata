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
  A kliknu na uložení
 
  Pak bych měl vidět "Profil úspěšně aktualizován."
  A měl bych vidět "jezisek2@rybickazlata.cz"
  A neměl bych vidět "pepik@rybickazlata.cz "

Scénář: Změna jména
  Když kliknu v menu na "Profil"
  A kliknu na editaci
  A změním "pepik" na "Jozífek"
  A kliknu na uložení
 
  Pak bych měl vidět "Profil úspěšně aktualizován."
  A měl bych vidět "Jozífek"
  A neměl bych vidět "pepik"
