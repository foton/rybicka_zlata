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
                description: "Popis",
                updated_by_donne_at: "Čas poslední změny obdarovaným"
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

    wishes: {
        shared_icon_tooltip: {
            shared: "Sdílené přání má více obdarovaných",
            personal: "Osobní přání pouze jediného obdarovaného"
            },
        errors: {
            same_donor_and_donee: {
                by_connection: "Mezi obdarovanými je stejná kontakt jako v dárcích: '%{conn_fullname}'.",
                by_email: "Mezi obdarovanými je kontakt se stejným emailem jako jiná v dárcích: '%{email}'",
                by_user: "Mezi obdarovanými je stejný uživatel '%{donee_fullname}'  jako v dárcích '%{donor_fullname}'."
            },
            cannot_be_booked_by_donee: "Nemůže být rezervováno obdarovaným!",
            cannot_be_booked_in_this_state: "Nemůže mít, v tomto stavu, přiděleného rezervujícího uživatele!",
            must_have_booking_user: "Musí mít, v tomto stavu, přřazeného rezervujícího uživatele!"
        },
        actions: {
            new: {
                button: "Přidat přání"
            },
            edit: {
                button: "Upravit"
            },
            save: {
                button: "Zapsat"
            },
            delete: {
                button: "Smazat",
                confirm: {
                  message: "Opravdu chcete přání '%{wish_title}' smazat?"
                }
            },
            book: {
                button: "Rezervovat",
                message: "Přání '%{wish_title}' bylo zarezervováno pro '%{user_name}'"
            },
            unbook: {
                button: "Uvolnit",
                message: "Přání '%{wish_title}' bylo uvolněno pro ostatní dárce."
            },
            call_for_co_donors: {
                button: "Vyzvat ke spoluúčasti",
                message: "Uživatel '%{user_name}' hledá spoludárce pro přání '%{wish_title}'."
            } ,   
            withdraw_call: {
                button: "Zrušit výzvu ke spoluúčasti",
                message: "Uživatel '%{user_name}' zrušil svoji výzvu ke spoluúčasti u přání '%{wish_title}'."
            } ,   
            gifted: {
                button: "Darováno",
                message: "Přání '%{wish_title}' bylo darováno/splněno dárcem '%{user_name}'."
            },    
            fulfilled: {
                button: "Splněno",
                message: "Přání '%{wish_title}' bylo splněno."
            }    
        },
        donees: {
            header:"Obdarovaní"
        },
        donors: {
            header: "Dárci"
        },

        from_author: {
            views: {
                new: { 
                  title: "Titulek nového přání"
                },
                edit: { 
                  title: "Titulek přání",
                  description: "Širší popis",
                  donees: {
                    header: "Další obdarovaní",
                    help: "Jako první obdarovaný jste automaticky Vy (jako autor). Můžete ale přidat i další spoluobdarované z Vašich přátel. Ti pak budou moci přidat potenciální dárce ze svých přátel."
                  },
                  donors: {
                    help: "Zde můžete vybrat potenciální dárce. Tedy ty z Vašich přátel, kdo toto konkrétní přání uvidí a budou ho moci splnit. Případné neaktivní položky již figurují jako obdarovaní, proto je nelze vybrat."
                  },
                  unused_connections: {
                    header: "Nevyužití",
                    help: "Kontakty, kteří toto přání vůbec neuvidí. Pokud tu žádní nejsou, je možné že jste zatím žádné nezadali nebo už jsou v ostatních blocích."
                  }  
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
                    header: "Má přání",
                    header_fulfilled: "Má splněná přání"
                },
                list: {
                    header: "Seznam mých přání",
                    none: "Nemáte žádné přání. Přidejte si nějaké!",
                    none_fulfilled: "Nemáte žádné splněné přání. Co si to, proboha, vlastně přejete?"
                },
                show: {
                    name_for_author_connection: "Autor přání",
                    donors: {
                        count: "celkem: %{total} / vašich: %{owns}"
                    }
                },
                updated: "Seznam potenciálních dárců pro '%{title}' byl úspěšně aktualizován.",
                not_updated: "Přání '%{title}' nebylo aktualizováno.",
                deleted: "Byli jste odebráni z obdarovaných u přání '%{title}'.",
                not_deleted: "Nebyli jste odebráni z obdarovaných u přání '%{title}'.",
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
                },
                show: {
                    donees_list_header: "Obdarovaní"
                }
            }
        }    

    }
}}
