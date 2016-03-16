# encoding: utf-8
# language: cs
Požadavek:  Poslání hlášení porybnému
  Jako nepřihlášený uživatel/návštěvník
  chci mít možnost poslat zprávu Porybnému
  abych se aplikace mohla zlepšovat
Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem na úvodní stránce
  A přepnu na češtinu  

Scénář: Nepřihlášený uživatel posílá vzkaz
  Když kliknu na "Kontaktujte nás"
  A zapíšu do položky "Vaše zpráva pro Porybného" text "Prostě něco strašlivě důležitého."
  #A zapíšu do položky "recpatcha" text "NeznáméHeslo328"
  A zapíšu do položky "Kam má přijít případná reakce?" text "muj@email.cz"
  A kliknu na tlačítko "Odeslat"

  Pak bych měl vidět "Zpráva pro Porybného odeslána."
    
  Pokud si otevřu poslední email pro adresu "porybny@rybickazlata.cz"
  Pak jeho předmět by měl být "Zpráva pro Porybného od uživatele ''" 
  A v jeho obsahu by mělo být "Prostě něco strašlivě důležitého." 
  A v jeho obsahu by mělo být "Odpověď poslat na 'muj@email.cz'" 

Scénář: Přihlášený uživatel posílá vzkaz
  A jsem přihlášen jako "pepik"
  A kliknu na "Kontaktujte nás"
  A zapíšu do položky "Vaše zpráva pro Porybného" text "Prostě něco strašlivě důležitého."
  #A zapíšu do položky "recpatcha" text "NeznáméHeslo328"
  A zapíšu do položky "Kam má přijít případná reakce?" text "muj@email.cz"
  A kliknu na tlačítko "Odeslat"

  Pak bych měl vidět "Zpráva pro Porybného odeslána."
    
  Pokud si otevřu poslední email pro adresu "porybny@rybickazlata.cz"
  Pak jeho předmět by měl být "Zpráva pro Porybného od uživatele 'pepik'" 
  A v jeho obsahu by mělo být "Prostě něco strašlivě důležitého." 
  A v jeho obsahu by mělo být "Profil uživatele 'pepik': http://localhost:3000/profiles/"
 
