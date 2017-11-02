# frozen_string_literal: true

{ cs: {
  activerecord: {
    models: {
      group: {
        one: 'Skupina',
        other: 'Skupiny'
      }
    },
    attributes: {
      group: {
        name: 'Název'
      }
    },
    errors: {
      models: {
        group: {
          attributes: {
            name: {
              too_short: 'Tenhle Název je minimální až moc'
            }
          }
        }
      }
    }

  },

  groups: {
    actions: {
      new: {
        button: 'Přidat',
        next_button: 'Další'
      },
      save: {
        button: 'Zapsat'
      },
      edit: {
        button: 'Upravit'
      },
      delete: {
        button: 'Smazat',
        confirm: {
          message: "Opravdu chcete skupinu '%{object_title}' smazat?"
        }
      }
    },
    views: {
      header: 'Skupiny',
      help: 'Skupiny slouží při editaci přání pro přetahování více kontaktů najednou. Tj. zrychlují práci. A nejsou povinné.',
      add: {
        name: 'Název skupiny'
      },
      added: "Skupina '%{name}' byla úspěšně přidána. Nyní ji, prosím, naplňte lidmi.",
      not_added: "Skupina '%{name}' nebyla přidána.",
      updated: "Skupina '%{name}' byla úspěšně nastavena.",
      not_updated: "Skupina '%{name}' nebyla aktualizována.",
      deleted: "Skupina '%{name}' byla úspěšně smazána.",
      not_deleted: "Skupina '%{name}' nebyla smazána.",
      list: {
        header: 'Seznam skupin',
        none: 'Zatím žádná skupina'
      },
      delete: {
        confirm: {
          message: 'Opravdu smazat?'
        }
      }
    }
  }
} }
