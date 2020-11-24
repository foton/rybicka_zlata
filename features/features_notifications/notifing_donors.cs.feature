# encoding: utf-8
# language: cs

Požadavek: Notifikace o změnách v přáních pro dárce
  Jako přihlášený uživatel Bart
  chci vidět, jaká cizí přání se změnila
  abych měl rychle přehled

Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem přihlášen jako "Bart"
  A přepnu na češtinu

Scénář: Dostávám notifikace o změně
  Pokud jsem na stránce "Notifikace"
  Pak bych neměl vidět žádnou notifikaci k přání "M+H: Your parents on holiday"

  Pokud "Marge" změní přání "M+H: Your parents on holiday"
  A já si otevřu stránku "Notifikace"
  Pak bych měl vidět notifikaci "Marjorie Jacqueline Simpson změnil/a přání 'M+H: Your parents on holiday'"
  #Marjorie Jacqueline Simpson notified you of Wish (759609446) Nov 24

  Pokud mě "Marge" odebere z dárců přání "M+H: Your parents on holiday"
  A já si otevřu stránku "Notifikace"
  Pak bych měl vidět notifikaci "Marjorie Jacqueline Simpson změnil/a přání 'M+H: Your parents on holiday'"

  Pokud mě "Homer" zase přidá do dárců přání "M+H: Your parents on holiday"
  A já si otevřu stránku "Notifikace"
  Pak bych měl vidět notifikaci "Marjorie Jacqueline Simpson změnil/a přání 'M+H: Your parents on holiday'"
