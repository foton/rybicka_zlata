# encoding: utf-8
# language: cs

Požadavek: Práce s přáními jako dárce
  Jako přihlášený uživatel Karel
  chci mít možnost splnit cizí přání
  abych měl dobrý pocit z jejich radosti

Kontext:
  Pokud existují standardní testovací uživatelé

  A "Mařenka" má kontakt "maruska@example.com"
  A "Karel" má kontakt "karel@example.com"
  A "Karel" má kontakt "karel_maly@example.com"
  
  A u "pepika" existuje kontakt "Karel"
  A u "pepika" existuje kontakt "Mařenka" s adresou "marenka@rybickazlata.cz"
  A u "pepika" existuje skupina "Kámoši" se členy ["Hynek", "Vilda","Jarka"]
  A u "pepika" existuje skupina "Rodina" se členy ["Máma", "Táta" , "Mařenka"]

  A u "Mařenky" existuje kontakt "Karel Malý" s adresou "karel_maly@example.com"
  A u "Mařenky" existuje kontakt "Pepík" s adresou "pepik@rybickazlata.cz"
  A u "Mařenky" existuje skupina "Kámarádi" se členy ["Tom", "Bob"]
  A u "Mařenky" existuje skupina "Rodina" se členy ["Máma", "Táta", "Pepík"]
  
  #wish which is not visible to Karel
  Pokud existuje přání "Pračka" uživatele "pepik"
  A to má dárce ["Máma", "Táta"]
  A má v obdarovaných ["Maruška"]
  
  Pokud existuje přání "Dovolená v Karibiku" uživatele "pepik"
  A to má dárce ["Máma", "Táta", "Karel"]
  A má v obdarovaných ["Maruška"]

  Pokud existuje přání "Překvapení pro Pepu" uživatele "Mařenka"
  A to má dárce ["Máma", "Táta", "Karel Malý"]
  
  A přepnu na češtinu
  A jsem přihlášen jako "Karel"

Scénář: Vidím jen přání, kde jsem dárcem
  Pokud jsem na stránce "Můžu splnit"
  Pak bych měl vidět přání "Dovolená v Karibiku"
  A měl bych vidět přání "Překvapení pro Pepu"
  A neměl bych vidět přání "Pračka"

  A pokud si otevřu přání "Dovolená v Karibiku" u "Mařenka"
  
  Pak bych měl vidět nadpis "Dovolená v Karibiku"
  A měl bych vidět popis "Description of přání Dovolená v Karibiku"
  A měl bych vidět spoluobdarované ["pepik","Mařenka"]

@javascript
Scénář: Rezervuji si přání
  Pokud jsem na stránce "Můžu splnit"
  A u přání "Překvapení pro Pepu" jsou akce ["Vyzvat ke spoluúčasti","Rezervovat"]
  A kliknu na rezervaci u přání "Překvapení pro Pepu"
  
  Pak bych měl vidět "Přání 'Překvapení pro Pepu' bylo zarezervováno pro 'Karel'"
  A u přání "Překvapení pro Pepu" jsou akce ["Uvolnit","Darováno"]

  #čekám až zmizí 'snackbar' s rezervační hláškou
  Pokud počkám 1 sekundu  
  A kliknu na uvolnění rezervace u přání "Překvapení pro Pepu"

  Pak bych měl vidět "Přání 'Překvapení pro Pepu' bylo uvolněno pro ostatní dárce."
  A u přání "Překvapení pro Pepu" jsou akce ["Vyzvat ke spoluúčasti","Rezervovat"]

@javascript
Scénář: Vyzvu ke spoluúčasti
  Pokud jsem na stránce "Můžu splnit"
  A kliknu na výzvu ke spoluúčasti u přání "Překvapení pro Pepu"
  
  Pak bych měl vidět "Uživatel 'Karel' hledá spoludárce pro přání 'Překvapení pro Pepu'."
  A u přání "Překvapení pro Pepu" jsou akce ["Zrušit výzvu ke spoluúčasti","Rezervovat"]

  #čekám až zmizí 'snackbar' s hláškou
  Pokud počkám 1 sekundu  
  A kliknu na uvolnění výzvy u přání "Překvapení pro Pepu"

  Pak bych měl vidět "Uživatel 'Karel' zrušil svoji výzvu ke spoluúčasti u přání 'Překvapení pro Pepu'."
  A u přání "Překvapení pro Pepu" jsou akce ["Vyzvat ke spoluúčasti","Rezervovat"]

@javascript
Scénář: Splním rezervované přání
  Pokud jsem na stránce "Můžu splnit"
  A kliknu na rezervaci u přání "Překvapení pro Pepu"
  
  Pak bych měl vidět "Přání 'Překvapení pro Pepu' bylo zarezervováno pro 'Karel'"

  #čekám až zmizí 'snackbar'
  A počkám 1 sekundu  
  Pokud kliknu na darování u přání "Překvapení pro Pepu"
  
  Pak bych měl vidět "Přání 'Překvapení pro Pepu' bylo darováno/splněno dárcem 'Karel'."
  A u přání "Překvapení pro Pepu" nejsou žádné akce
