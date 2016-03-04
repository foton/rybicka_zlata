{cs: {
    activerecord: {
        models: {
            connection: {
                one: "Přátelství",
                other: "Přátelství"
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
            button: "Smazat"
          }

        },
        views: {
            header: "Přátelé",
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
                header: "Seznam přátel",
                none: "Zatím žádní přátelé"
            },
            delete: {
                confirm: {
                    message: "Opravdu smazat?"
                }
            }
        }
    }
}}
