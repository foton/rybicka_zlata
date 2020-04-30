# encoding: utf-8
# language: cs

# TODO: Groups was removed from menu, beacuse there are not used yet in wish creation. So they are useles now.
# TODO: Also, edit of group should be draggable (no checkboxes)

 Požadavek: Přidání kontaktů na mé potenciální dárce
   Jako přihlášený uživatel
   chci mít možnost spravovat skupiny lidí
   abych je mohl přiřazovat jako dárce nebo spoluobdarované

Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem přihlášen jako "Bart"
  A přepnu na češtinu

Scénář: Přidání skupiny
  Pokud  existuje kontakt "Mom"
  A existuje kontakt "Dad"

  Pokud jsem na stránce "Skupiny"
  A otevřu si formulář pro přidání
  A zapíšu do položky "Název" text "Rodina"
  A kliknu na pokračování

  Pak jsem na stránce editace skupiny "Rodina"
  A vidím text "Skupina 'Rodina' byla úspěšně přidána. Nyní ji, prosím, naplňte lidmi."
  A do seznamu přidám "Mom"
  A do seznamu přidám "Dad"
  A kliknu na uložení

  Pak jsem na stránce "Skupina Rodina"
  A vidím text "Skupina 'Rodina' byla úspěšně nastavena."
  A vidím kontakt "Mom"
  A vidím kontakt "Dad"

  Pokud jsem na stránce "Skupiny"
  A v seznamu skupin je skupina "Rodina" se 2 členy

@javascript
Scénář: Úprava skupiny
  Pokud existuje skupina "Kámoši" se členy ["Hynek", "Vilda","Jarka"]
  A existuje kontakt "Milhouse"

  A jsem na stránce "Skupiny"
  A kliknu na editaci u "Kámoši"

  Pak jsem na stránce editace skupiny "Kámoši"
  A změním "Kámoši" na "Kemoši"
  A vyřadím "Hynek"
  A vyřadím "Vilda"
  A přidám "Milhouse"
  A kliknu na uložení
  A počkám 1 sekundu

  Pak jsem na stránce "Skupina Kemoši"
  A vidím text "Skupina 'Kemoši' byla úspěšně nastavena."
  A vidím kontakt "Jarka"
  A vidím kontakt "Milhouse"
  A nevidím kontakt "Hynek"
  A nevidím kontakt "Vilda"

  Pokud jsem na stránce "Skupiny"
  Pak v seznamu skupin není skupina "Kámoši"
  A v seznamu skupin je skupina "Kemoši" s 2 členy

@javascript
Scénář: Odstranění skupiny
  Pokud existuje skupina "Kámoši" se členy ["Hynek", "Vilda","Jarka"]
  A jsem na stránce "Skupiny"
  A kliknu na smazání u "Kámoši"
  A smazání potvrdím

  Pak jsem na stránce "Skupiny"
  A vidím text "Skupina 'Kámoši' byla úspěšně smazána."
  A v seznamu skupin není skupina "Kámoši"


