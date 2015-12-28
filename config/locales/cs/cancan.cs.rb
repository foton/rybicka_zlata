# encoding: utf-8 
#hlasky pro CanCan
 {:'cs' => {
     :unauthorized=> {
        :default => "Nejste oprávněni zobrazit si požadovanou stránku či provést požadovanou akci.",
        :manage=> {:all => "Nejste oprávněni provádět akci %{action} nad objektem %{subject}."},
        :update => {:all => "Nejste oprávněni provádět upravovat objekt %{subject}."},
        :create => {:all => "Nejste oprávněni vytvářet nové objekty typu %{subject}."},
        :read => {:all => "Nejste oprávněni zobrazit tento/tyto objekt/y."},
        :destroy => {:all => "Nejste oprávněni smazat tento objekt."}
                    }
          }
  }   