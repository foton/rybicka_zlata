# frozen_string_literal: true

{ en: {
  activerecord: {
    models: {
      wish: {
        one: 'Wish',
        other: 'Wishes'
      }
    },
    attributes: {
      wish: {
        title: 'Title',
        description: 'Description'
      }
    },
    errors: {
      models: {
        wish: {
          attributes: {
            title: {
              too_short: 'This Tile is minimized too much'
            }
          }
        }
      }
    }

  },

  wishes: {
    shared_icon_tooltip: {
      shared: 'Shared wish wit more donees',
      personal: 'Personal wish with only one donee'
    },
    errors: {
      same_donor_and_donee: {
        by_connection: "There is same connection between donees and donors: '%<conn_fullname>s'.",
        by_email: "There is connection with same email between donees and donors: '%<email>s'",
        by_user: "There is same user in donees: '%<donee_fullname>s' as in donors: '%<donor_fullname>s'."
      },
      cannot_be_booked_by_donee: 'Can not be booked by donee!',
      cannot_be_booked_in_this_state: 'In this state, wish can not be booked by user!',
      cannot_be_called_in_this_state: 'In this state, wish can not be called for co-donors!',
      must_have_booking_user: 'In this state, wish must have booking user!',
      donee_cannot_call_for_co_donors: 'Donee can not call for co-donors!',
      must_have_calling_by_user: 'Must have calling by user!'
    },
    actions: {
      no_action_available: 'This wish is booked. You can do nothing with it.',
      new: {
        button: 'Add wish'
      },
      another_new: {
        button: 'Add another wish'
      },
      show: {
        button: 'Show'
      },
      edit: {
        button: 'Edit'
      },
      save: {
        button: 'Save'
      },
      delete: {
        button: 'Delete',
        confirm: {
          message: "Do you really want to delete wish '%<object_title>s'?"
        }
      },
      book: {
        button: 'Book',
        message: "Wish '%<wish_title>s' was booked for '%<user_name>s'"
      },
      unbook: {
        button: 'Unbook',
        message: "Wish '%<object_title>s' was unbooked."
      },
      call_for_co_donors: {
        button: 'Call for donors',
        message: "User '%<user_name>s' looking for another donors for wish '%<wish_title>s'. Contact him/her.",
        notice: "User '%<user_name>s' looking for another donors for this wish. Contact him/her."
      },
      withdraw_call: {
        button: 'Withdraw call',
        message: "User '%<user_name>s' withdraw his/hers call for co-donors for wish '%<wish_title>s'."
      },
      gifted: {
        button: 'Gifted',
        message: "Wish '%<wish_title>s' was gifted/fulfilled by donor '%<user_name>s'."
      },
      fulfilled: {
        button: 'fulfilled',
        message: "Wish '%<wish_title>s' was fulfilled."
      }
    },
    donees: {
      header: 'Donees'
    },
    donors: {
      header: 'Donors'
    },

    from_author: {
      views: {
        new: {
          title: 'New wish title'
        },
        edit: {
          title: ' Title of wish',
          description: 'Description',
          groups_are_good_for: 'Groups below can be used to move more connections at once. If you drop group on block, all connections from it, no matter where they are now, are moved to the same block.',
          donees: {
            header: 'Other donees',
            help: "Author of wish is it's first donee. You can add more donees and create shared wish. Other donees can only add more donors from theirs friends."
          },
          donors: {
            help: 'Add potentional donors here. These are some of your friends, who will see this wish and can fulfill it. Nonactive items are already in donees, so You can not choose them as donors.'
          },
          unused_connections: {
            header: 'Unused',
            help: 'Your friends, which can not see this wish. If there are none, You maybe do not have any connection in Friends or all of them are already in other blocks.'
          }
        },
        added: "Wish '%<title>s' was successfully created.",
        not_added: "Wish '%<title>s' was not created.",
        updated: "Wish '%<title>s' was successfully updated.",
        not_updated: "Wish '%<title>s' was not updated.",
        deleted: "Wish '%<title>s' was successfully deleted.",
        not_deleted: "Wish '%<title>s' was not deleted.",
        delete: {
          confirm: {
            message: 'Really delete?'
          }
        }
      }

    },

    from_donee: {
      views: {
        index: {
          header: 'My wishes',
          header_fulfilled: 'My fulfilled wishes',
          no_wishes: 'You do not have any wish, add some!',
          no_fulfilled_wishes: 'You do not have any fulfilled wish. Are you wishing World Peace only?'
        },
        show: {
          name_for_author_connection: 'Author of the wish',
          donors: {
            count: 'Total: %<total>s / Yours: %<owns>s'
          }
        },
        updated: "Potentional donor list for '%<title>s' was successfully updated.",
        not_updated: "Wish '%<title>s' was not updated.",
        deleted: "You were removed from donees of '%<title>s'.",
        not_deleted: "You were not removed from donees of '%<title>s'",
        delete: {
          confirm: {
            message: 'Really delete?'
          }
        }
      }

    },
    from_donor: {
      views: {
        index: {
          header: 'Can fulfill',
          no_wishes: 'Nobody set you as potencial donor. Are they all afraid of You or what?'
        },
        list: {
          none: 'Wants nothing new from You.'
        },
        show: {
          donees_list_header: 'Donees'
        },
        updated: "Wish '%<title>s' was successfully updated.",
        not_updated: "Wish '%<title>s' was not updated."

      }
    }

  }
} }
