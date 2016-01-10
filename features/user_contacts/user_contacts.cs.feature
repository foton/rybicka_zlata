# encoding: utf-8
# language: cs
Požadavek: Operace s vlastními kontakty
  Jako přihlášený uživatel
  chci měnit seznam kontaktů na mě
  aby mě uživatelé mohli najít podle kontaktu, který oni znají

Kontext:
  Pokud se přihlásím
  A přepnu na češtinu  
  A jsem na stránce "Kontakty na mě"


Scénář: Přidání kontaktu
   Když kliknu na "+" 
   A zadám adresu "cucky.pracky@kotrmelci.cz"
   A kliknu na "Přidat"
   Pak je v seznamu mých e-mailových adres měl vidět i "cucky.pracky@kotrmelci.cz"

Scénář: Smazání kontaktu
   Když u emailové adresy "basama@fousama.cz" kliknu na ikonu smazání
   A smazání potvrdím
   Pak v seznamu už není adresa "basama@fousama.cz"
   A vidím text "E.amilová adresa basama@fousama.cz byla smazána"
   A uživatelům, kteří ji používali o tom přijde e-mail
