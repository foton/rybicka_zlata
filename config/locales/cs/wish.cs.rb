{cs: {
    activerecord: {
        models: {
            wish: {
                one: "Přání",
                other: "Přání"
            }
        },
        attributes: {
            wish: {
                title: "Titulek",
                description: "Popis"
            }
        },
        errors: {
            models: {
                wish: {
                    attributes: {
                        title: {
                            too_short: "Tenhle Titulek je minimální až moc"
                        }
                    }
                }
            }
        }

    },

    wish: {
        from_author: {
            views: {
                add: { 
                  title: "Titulek nového přání",
                  description: "Širší popis"
                },
                added: "Přání '%{title}' bylo úspěšně přidáno.",
                not_added: "Přání '%{title}' nebylo přidáno.",
                updated: "Přání '%{title}' bylo úspěšně aktualizováno.",
                not_updated: "Přání '%{title}' nebylo aktualizováno.",
                deleted: "Přání '%{title}' bylo úspěšně smazáno.",
                not_deleted: "Přání '%{title}' nebylo smazáno.",
                delete: {
                    confirm: {
                        message: "Opravdu smazat?"
                    }
                }    
            }

        },

        from_donee: {
            views: {
                index: {
                    header: "Má přání"
                },
                list: {
                    header: "Seznam mých přání",
                    none: "Nemáte žádné přání. Přidejte si nějaké!"
                },
                updated: "Seznam potenciálních dárců pro '%{title}' byl úspěšně aktualizován.",
                not_updated: "Přání '%{title}' nebylo aktualizováno.",
                deleted: "'%{title}' bylo vyřazeno z vašich přání.",
                not_deleted: "Přání '%{title}' nebylo odstraněno.",
                delete: {
                    confirm: {
                        message: "Opravdu smazat?"
                    }
                }    
            }

        },
        from_donor: {
            views: {
                index: {
                    header: "Můžu splnit"
                }
            }
        }    

    }
}}
