{cs: {
    activerecord: {
        models: {
            group: {
                one: "Skupina",
                other: "Skupiny"
            }
        },
        attributes: {
            group: {
                name: "Název"
            }
        },
        errors: {
            models: {
                group: {
                    attributes: {
                        name: {
                            too_short: "Tenhle Název je minimální až moc"
                        }
                    }
                }
            }
        }

    },

    group: {
        views: {
            header: "Skupiny",
            add: { 
              name: "Název"
            },
            added: "Skupina '%{name}' byla úspěšně přidána. Nyní ji, prosím, naplňte lidmi?y.",
            not_added: "Skupina '%{name}' nebyla přidána.",
            updated: "Skupina '%{name}' byla úspěšně aktualizována.",
            not_updated: "Skupina '%{name}' nebyla aktualizována.",
            deleted: "Skupina '%{name}' byla úspěšně smazána.",
            not_deleted: "Skupina '%{name}' nebyla smazána.",
            list: {
                header: "Seznam skupin",
                none: "Zatím žádná skupina"
            },
            delete: {
                confirm: {
                    message: "Opravdu smazat?"
                }
            }
        }
    }
}}