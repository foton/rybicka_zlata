# encoding: utf-8
# language: cs

Požadavek: Práce s přáními jako dárce
  Jako přihlášený uživatel Karel
  chci mít možnost splnit cizí přání
  abych měl dobrý pocit z jejich radosti

Kontext:
  Pokud existují standardní testovací uživatelé

  # wish which is not visible to Bart aka 'Son'
  Pokud přidám přání "Pračka" uživatele "Marge" pro dárce { "Marge" => ["Husband", "Daughter"] }

  Pokud existuje přání "M+H: Your parents on holiday" uživatele "Marge"
  A to má dárce { "Homer" => ["MiniMe"], "Marge" => ["Bart"] }
  A má v obdarovaných ["Homer"]

  Pokud existuje přání "Lisa wish (shown only to Bart)" uživatele "Lisa"
  A to má dárce { "Líza" => ["Misfit"] }

  A přepnu na češtinu
  A jsem přihlášen jako "Bart"

Scénář: Vidím jen přání, kde jsem dárcem
  Pokud jsem na stránce "Můžu splnit"
  Pak bych měl vidět přání "M+H: Your parents on holiday"
  A měl bych vidět přání "Lisa wish (shown only to Bart) Tatoo at my spine!"
  A měl bych vidět přání "M: Taller hairs"
  A neměl bych vidět přání "Pračka"

  A pokud si otevřu přání "M+H: Your parents on holiday" u "Mom"

  Pak bych měl vidět nadpis "M+H: Your parents on holiday"
  A měl bych vidět popis "Nice holiday without children. (Donors: M:Lisa, H:Bart)"
  A měl bych vidět spoluobdarované ["Dad","Mom"]

@javascript
Scénář: Rezervuji si přání
  Pokud jsem na stránce "Můžu splnit"
  A u přání "M: Taller hairs" jsou akce ["Vyzvat ke spoluúčasti","Rezervovat"]
  A kliknu na rezervaci u přání "M: Taller hairs"

  Pak bych měl vidět "Přání 'M: Taller hairs' bylo zarezervováno pro 'Bartholomew JoJo Simpson'"
  A u přání "M: Taller hairs" jsou akce ["Uvolnit","Darováno"]

  # čekám až zmizí 'snackbar' s rezervační hláškou
  Pokud počkám 1 sekundu
  A kliknu na uvolnění rezervace u přání "M: Taller hairs"

  Pak bych měl vidět "Přání 'M: Taller hairs' bylo uvolněno pro ostatní dárce."
  A u přání "M: Taller hairs" jsou akce ["Vyzvat ke spoluúčasti","Rezervovat"]

@javascript
Scénář: Vyzvu ke spoluúčasti
  Pokud jsem na stránce "Můžu splnit"
  A kliknu na výzvu ke spoluúčasti u přání "M: Taller hairs"

  Pak bych měl vidět "Uživatel 'Bartholomew JoJo Simpson' hledá spoludárce pro přání 'M: Taller hairs'."
  A u přání "M: Taller hairs" jsou akce ["Zrušit výzvu","Rezervovat"]

  # čekám až zmizí 'snackbar' s hláškou
  Pokud počkám 1 sekundu
  A kliknu na uvolnění výzvy u přání "M: Taller hairs"

  Pak bych měl vidět "Uživatel 'Bartholomew JoJo Simpson' zrušil svoji výzvu ke spoluúčasti u přání 'M: Taller hairs'."
  A u přání "M: Taller hairs" jsou akce ["Vyzvat ke spoluúčasti","Rezervovat"]

@javascript
Scénář: Přebiji výzvu ke spoluúčasti
  Pokud jsem na stránce "Můžu splnit"
  A kliknu na výzvu ke spoluúčasti u přání "M: Taller hairs"

  Pak bych měl vidět "Uživatel 'Bartholomew JoJo Simpson' hledá spoludárce pro přání 'M: Taller hairs'."
  A u přání "M: Taller hairs" jsou akce ["Zrušit výzvu","Rezervovat"]

  Pokud jsem na stránce "Profil"
  Pokud se odhlásím
  A jsem přihlášen jako "Lisa"

  Pokud jsem na stránce "Můžu splnit"
  A kliknu na rezervaci u přání "M: Taller hairs"

  Pak bych měl vidět "Přání 'M: Taller hairs' bylo zarezervováno pro 'Lisa Marie Simpson'"
  A u přání "M: Taller hairs" jsou akce ["Uvolnit","Darováno"]

@javascript
Scénář: Splním rezervované přání
  Pokud jsem na stránce "Můžu splnit"
  A kliknu na rezervaci u přání "M: Taller hairs"

  Pak bych měl vidět "Přání 'M: Taller hairs' bylo zarezervováno pro 'Bartholomew JoJo Simpson'"

  # čekám až zmizí 'snackbar'
  A počkám 1 sekundu
  Pokud kliknu na darování u přání "M: Taller hairs"

  Pak bych měl vidět "Přání 'M: Taller hairs' bylo darováno/splněno dárcem 'Bartholomew JoJo Simpson'."
  A u přání "M: Taller hairs" nejsou žádné akce
