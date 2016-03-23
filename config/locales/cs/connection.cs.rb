{cs: {
    activerecord: {
        models: {
            connection: {
                one: "Kontakt",
                other: "Kontakty"
            }
        },
        attributes: {
            connection: {
                name: "Jméno",
                email: "E-mail"
            }
        },
        errors: {
            models: {
                connection: {
                    attributes: {
                        name: {
                            too_short: "Tohle Jméno je minimální až moc"
                        }
                    }
                }
            }
        }

    },

    connections: {
        base_cover_name: "Autor přání",
        friend_deleted: "zrušen",
        actions: {
          new: { 
            button: "Přidat"
          },
          save: {
            button: "Zapsat"
          },
          edit: {
            button: "Upravit"
          },
          delete: {
            button: "Smazat",
            confirm: {
              message: "Opravdu chcete kontakt '%{object_title}' smazat?"
            }
          }

        },
        views: {
            header: "Kontakty",
            help: "Svá přání sdílíte s ostatními prostřednictvím kontaktů (obdarovaní/dárci).\nPokud je uživatel s odpovídající emailovou adresou registrován na Rybičce, je jméno jeho účtu v hranatých závorkách.\nPokud není, jsou tam tři otazníky. Jméno se tam pak objeví po jeho registraci.\nKontakty bez uživatele jsou tedy dobré 'do foroty'.",
            add: {
                name: "Jméno",
                email: "E-mail"
            },
            added: "Kontakt '%{fullname}' byl úspěšně přidán.",
            not_added: "Kontakt '%{fullname}' nebyl přidán.",
            updated: "Kontakt '%{fullname}' byl úspěšně aktualizován.",
            not_updated: "Kontakt '%{fullname}' nebyl aktualizován.",
            deleted: "Kontakt '%{fullname}' byl úspěšně smazán.",
            not_deleted: "Kontakt '%{fullname}' nebyl smazán.",
            list: {
                header: "Seznam kontaktů",
                none: "Zatím žádné kontakty"
            },
            delete: {
                confirm: {
                    message: "Opravdu smazat?"
                }
            }
        }
    }
}}
