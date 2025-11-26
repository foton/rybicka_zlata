# frozen_string_literal: true

{ cs: {
  activerecord: {
    models: {
      wish: {
        one: 'Přání',
        other: 'Přání'
      }
    },
    attributes: {
      wish: {
        title: 'Titulek',
        description: 'Popis',
        updated_by_donee_at: 'Čas poslední změny obdarovaným'
      }
    },
    errors: {
      models: {
        wish: {
          attributes: {
            title: {
              too_short: 'Tenhle Titulek je minimální až moc'
            }
          }
        }
      }
    }

  },
  wish: {
    notifications: {
      updated: 'Aktualizováno kým'
    }
  },

  wishes: {
    shared_icon_tooltip: {
      shared: 'Sdílené přání má více obdarovaných',
      personal: 'Osobní přání pouze jediného obdarovaného'
    },
    errors: {
      same_donor_and_donee: {
        by_connection: "Mezi obdarovanými je stejný kontakt jako v dárcích: '%<conn_fullname>s'.",
        by_email: "Mezi obdarovanými je kontakt se stejným emailem jako jiná v dárcích: '%<email>s'",
        by_user: "Mezi obdarovanými je stejný uživatel '%<donee_fullname>s' jako v dárcích '%<donor_fullname>s'."
      },
      cannot_be_booked_by_donee: 'Nemůže být rezervováno obdarovaným!',
      cannot_be_booked_in_this_state: 'Nemůže mít, v tomto stavu, přiděleného rezervujícího uživatele!',
      cannot_be_called_in_this_state: 'Nemůže v tomto stavu vyzývat ke spoluúčasti!',
      must_have_booking_user: 'Musí mít, v tomto stavu, přřazeného rezervujícího uživatele!',
      donee_cannot_call_for_co_donors: 'Obdarovaný nemůže vyzývat ke spoluúčasti!',
      must_have_calling_by_user: 'Musí mít vyzývajícího uživatele!'
    },
    actions: {
      no_action_available: 'S tímhle přáním už neuděláte nic. Asi je již zadáno.',
      new: {
        button: 'Přidat přání'
      },
      another_new: {
        button: 'Přidat další přání'
      },
      show: {
        button: 'Zobrazit'
      },
      edit: {
        button: 'Upravit'
      },
      save: {
        button: 'Zapsat'
      },
      delete: {
        button: 'Smazat',
        confirm: {
          message: "Opravdu chcete přání '%<object_title>s' smazat?"
        }
      },
      book: {
        button: 'Rezervovat',
        message: "Přání '%<wish_title>s' bylo zarezervováno pro '%<user_name>s'"
      },
      unbook: {
        button: 'Uvolnit',
        message: "Přání '%<wish_title>s' bylo uvolněno pro ostatní dárce."
      },
      call_for_co_donors: {
        button: 'Vyzvat ke spoluúčasti',
        message: "Uživatel '%<user_name>s' hledá spoludárce pro přání '%<wish_title>s'. Ozvěte se mu.",
        notice: "Uživatel '%<user_name>s' hledá spoludárce pro toto přání. Ozvěte se mu."
      },
      withdraw_call: {
        button: 'Zrušit výzvu',
        message: "Uživatel '%<user_name>s' zrušil svoji výzvu ke spoluúčasti u přání '%<wish_title>s'."
      },
      gifted: {
        button: 'Darováno',
        message: "Přání '%<wish_title>s' bylo darováno/splněno dárcem '%<user_name>s'."
      },
      fulfilled: {
        button: 'Splněno',
        message: "Přání '%<wish_title>s' bylo splněno."
      }
    },
    donees: {
      header: 'Obdarovaní'
    },
    donors: {
      header: 'Dárci'
    },

    from_author: {
      views: {
        new: {
          title: 'Titulek nového přání'
        },
        edit: {
          title: 'Titulek přání',
          description: 'Širší popis',
          groups_are_good_for: 'Skupiny níže slouží jako pomocné položky pro přetahování více kontaktů najednou. Pokud přesunete skupinu, okamžitě se všechny její kontakty, ať jsou kde jsou, přesunou do stejného bloku.',
          donees: {
            header: 'Další obdarovaní',
            help: 'Jako první obdarovaný jste automaticky Vy (jako autor). Můžete ale přidat i další spoluobdarované z Vašich kontaktů. Ti pak budou moci přidat další potenciální dárce.'
          },
          donors: {
            help: 'Sem můžete přidat potenciální dárce. Tedy ty z Vašich kontaktů, kdo toto konkrétní přání uvidí a budou ho moci splnit.'
          },
          unused_connections: {
            header: 'Nevyužití',
            help: 'Kontakty, které toto přání vůbec neuvidí. Pokud tu žádné nejsou, je možné že jste zatím žádné nezadali nebo už jsou v ostatních blocích nebo už jsou uvedeni jako obdarovaní autorem přání.'
          }
        },
        added: "Přání '%<title>s' bylo úspěšně přidáno.",
        not_added: "Přání '%<title>s' nebylo přidáno.",
        updated: "Přání '%<title>s' bylo úspěšně aktualizováno.",
        not_updated: "Přání '%<title>s' nebylo aktualizováno.",
        deleted: "Přání '%<title>s' bylo úspěšně smazáno.",
        not_deleted: "Přání '%<title>s' nebylo smazáno.",
        delete: {
          confirm: {
            message: 'Opravdu smazat?'
          }
        }
      }

    },

    from_donee: {
      views: {
        index: {
          header: 'Má přání',
          header_fulfilled: 'Má splněná přání',
          no_wishes: 'Nemáte žádné přání. Přidejte si nějaké!',
          no_fulfilled_wishes: 'Nemáte žádné splněné přání. Co si to, proboha, vlastně přejete?'
        },
        show: {
          name_for_author_connection: 'Autor přání',
          donors: {
            count: 'celkem: %<total>s / vašich: %<owns>s'
          }
        },
        updated: "Seznam potenciálních dárců pro '%<title>s' byl úspěšně aktualizován.",
        not_updated: "Přání '%<title>s' nebylo aktualizováno.",
        deleted: "Byli jste odebráni z obdarovaných u přání '%<title>s'.",
        not_deleted: "Nebyli jste odebráni z obdarovaných u přání '%<title>s'.",
        delete: {
          confirm: {
            message: 'Opravdu smazat?'
          }
        }
      }

    },

    from_donor: {
      views: {
        index: {
          header: 'Můžu splnit',
          no_wishes: 'Nikdo Vás zatím neuvedl jako potenciálního dárce u přání. To se Vás všichni bojí?'
        },
        list: {
          none: 'Nepřeje si od Vás nic nového.'
        },
        show: {
          donees_list_header: 'Obdarovaní'
        },
        updated: "Přání '%<title>s' bylo aktualizováno.",
        not_updated: "Přání '%<title>s' nebylo aktualizováno."

      }
    }

  }
} }
