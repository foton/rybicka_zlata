# encoding: utf-8
# language: cs

Požadavek: Přidání kontaktů na mé potenciální dárce
  Jako přihlášený uživatel 
  chci mít možnost spravovat skupiny lidí
  abych je mohl přiřazovat jako dárce nebo spoluobdarované

Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem přihlášen jako "pepik"
  A přepnu na češtinu  
  A jsem na stránce "Skupiny"

Scénář: Přidání skupiny
  Pokud kliknu na "+"
  A zapíšu do položky "Název" text "Rodina"
  A do seznamu přidám "Máma"
  A do seznamu přidám "Táta"
  A kliknu na "Přidat"

  Pak jsem na stránce "Skupiny"
  A vidím text "Skupina 'Rodina' byla úspešně přidána."
  A v seznamu skupin je "Rodina" se členy ["Máma","Táta"] 

Scénář: Úprava skupiny
  Pokud existuje skupina "Kámoši" se členy ["Hynek", "Vilda","Jarka"]
  A kliknu na editaci u "Kámoši"

  Pak jsem na stránce editace skupiny "Kámoši"
  A změním "Kámoši" na "Kemoši"
  A vyřadím "Hynek"
  A přidám "Karel"
  A kliknu na "Uložit"

  Pak jsem na stránce "Skupiny"
  A vidím text "Skupina 'Kemoši' byla úspešně změněna."
  A v seznamu skupin není skupina "Kámoši"
  A v seznamu skupin je skupina "Kemoši" se členy ["Karel", "Vilda","Jarka"]

Scénář: Odstranění skupiny
  Pokud existuje skupina "Kámoši" se členy ["Hynek", "Vilda","Jarka"]
  A kliknu na smazání u "Kámoši"
  A smazání potvrdím

  Pak jsem na stránce "Skupiny"
  A vidím text "Skupina 'Kámoši' byla úspešně smazána."
  A v seznamu skupin není skupina "Kámoši"


