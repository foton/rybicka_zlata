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
  
  A u "pepika" existuje konexe "Karel"
  A u "pepika" existuje konexe "Mařenka" s adresou "marenka@rybickazlata.cz"
  #A u "pepika" existuje skupina "Kámoši" se členy ["Hynek", "Vilda","Jarka"]
  A u "pepika" existuje skupina "Rodina" se členy ["Máma", "Táta" , "Mařenka"]

  A u "Mařenky" existuje konexe "Karel Malý" s adresou "karel_maly@example.com"
  A u "Mařenky" existuje konexe "Pepík" s adresou "pepik@rybickazlata.cz"
  #A u "Mařenky" existuje skupina "Kámarádi" se členy ["Tom", "Bob"]
  A u "Mařenky" existuje skupina "Rodina" se členy ["Máma", "Táta", "Pepík"]
  
  #visible wish which is not visible to Karel
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

Scénář: Rezervuji si přání
  Pokud jsem na stránce "Můžu splnit"
  A u přání "Překvapení pro Pepu" jsou akce ["Vyzvat ke spoluúčasti","Rezervovat"]
  A kliknu na rezervaci u přání "Překvapení pro Pepu"
  
  Pak bych měl vidět "Přání 'Překvapení pro Pepu' bylo zarezervováno pro Vás."
  A u přání "Překvapení pro Pepu" jsou akce ["Uvolnit","Splněno"]

  Pokud kliknu na uvolnění rezervace u přání "Překvapení pro Pepu"

  Pak bych měl vidět "Přání 'Překvapení pro Pepu' bylo uvolněno pro ostatní dárce."
  A u přání "Překvapení pro Pepu" jsou akce ["Vyzvat ke spoluúčasti","Rezervovat"]

Scénář: Vyzvu ke spoluúčasti
  Pokud jsem na stránce "Můžu splnit"
  A kliknu na výzvu ke spoluúčasti u přání "Překvapení pro Pepu"
  
  Pak bych měl vidět "K přání 'Překvapení pro Pepu' byla přidána výzva ke spoluúčasti."
  A u přání "Překvapení pro Pepu" jsou akce ["Uvolnit","Rezervovat"]

  Pokud kliknu na uvolnění výzvy u přání "Překvapení pro Pepu"

  Pak bych měl vidět "Přání 'Překvapení pro Pepu' bylo uvolněno pro ostatní dárce."
  A u přání "Překvapení pro Pepu" jsou akce ["Vyzvat ke spoluúčasti","Rezervovat"]

Scénář: Splním rezervované přání
  Pokud jsem na stránce "Můžu splnit"
  A kliknu na rezervaci u přání "Překvapení pro Pepu"
  
  Pak bych měl vidět "Přání 'Překvapení pro Pepu' bylo zarezervováno pro Vás."
  Pokud kliknu na splnění přání "Překvapení pro Pepu"
  
  Pak bych měl vidět "Přání 'Překvapení pro Pepu' bylo zařízeno, zbývá ho jen předat obdarovaným."
  A u přání "Překvapení pro Pepu" jsou akce ["Předáno"]
