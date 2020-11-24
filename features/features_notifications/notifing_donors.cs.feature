# encoding: utf-8
# language: cs

Požadavek: Notifikace o změnách v přáních pro dárce
  Jako přihlášený uživatel
  chci vidět, jaká cizí přání se změnila
  abych měl rychle přehled

Kontext:
  Pokud existují standardní testovací uživatelé
  A jsem přihlášen jako "Lisa"
  A přepnu na češtinu

Scénář: Dostávám notifikace o změně
  Pokud jsem na stránce "Notifikace"
  Pak bych neměl vidět žádnou notifikaci k přání "M+H: Your parents on holiday"

  Pokud "Marge" změní přání "M+H: Your parents on holiday"
  A já si otevřu stránku "Notifikace"
  Pak bych měl vidět notifikaci "Marjorie Jacqueline Simpson změnil/a přání 'M+H: Your parents on holiday'"

  Pokud mě "Marge" odebere z dárců přání "M+H: Your parents on holiday"
  A já si otevřu stránku "Notifikace"
  Pak bych měl vidět notifikaci "Marjorie Jacqueline Simpson Vás odebral/a z dárců u přání 'M+H: Your parents on holiday'"

  Pokud na mě má "Homer" kontakt
  A "Homer" mě zase přidá do dárců přání "M+H: Your parents on holiday"
  A já si otevřu stránku "Notifikace"
  # TODO: Pak bych měl vidět notifikaci "Homer Vás přidal/a do dárců u přání 'M+H: Your parents on holiday'"
  Pak bych měl vidět notifikaci "Homer Jay Simpson změnil/a přání 'M+H: Your parents on holiday'"
