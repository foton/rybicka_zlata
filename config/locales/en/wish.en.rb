{en: {
    activerecord: {
        models: {
            wish: {
                one: "Wish",
                other: "Wishes"
            }
        },
        attributes: {
            wish: {
                title: "Title",
                description: "Description"
            }
        },
        errors: {
            models: {
                wish: {
                    attributes: {
                        title: {
                            too_short: "This Tile is minimized too much"
                        }
                    }
                }
            }
        }

    },

   wishes: {
        errors: {
            same_donor_and_donee: {
                by_connection: "There is same connection between donees and donors: '%{conn_fullname}'.",
                by_email: "There is connection with same email between donees and donors: '%{email}'",
                by_user: "There is same user in donnes: '%{donee_fullname}' as in donors: '%{donor_fullname}'."
            },
            cannot_be_booked_by_donee: "Can not be booked by donee!",
            cannot_be_booked_in_this_state: "In this state, wish can not be booked by user!",
            must_have_booking_user: "In this state, wish must have booking user!"
        },
        actions: {
            new: {
                button: "Add wish"
            },
            edit: {
                button: "Edit"
            },
            save: {
                button: "Save"
            },
            delete: {
                button: "Delete",
                confirm: {
                  message: "Do you really want to delete wish '%{wish_title}'?"
                }
            },
            book: {
                button: "Book",
                message: "Wish '%{wish_title}' was booked for '%{user_name}'"
            },
            unbook: {
                button: "Unbook",
                message: "Wish '%{wish_title}' was unbooked."
            },
            call_for_co_donors: {
                button: "Call for donors",
                message: "User '%{user_name}' looking for another donors for wish '%{wish_title}'."
            } ,   
            withdraw_call: {
                button: "Withdraw call for co-donors",
                message: "User '%{user_name}' withdraw his/hers call for co-donors for wish '%{wish_title}'."
            } ,   
            gifted: {
                button: "Gifted",
                message: "Wish '%{wish_title}' was gifted/fullfilled by donor '%{user_name}'."
            },    
            fullfilled: {
                button: "Fullfilled",
                message: "Wish '%{wish_title}' was fullfilled."
            }    
        },
        donees: {
            header:"Donees"
        },
        donors: {
            header: "Donors"
        },

        from_author: {
            views: {
                new: { 
                  title: "New wish title"
                },
                edit: { 
                  title: " Title of wish",
                  description: "Description",
                  donees: {
                    header: "Other donees",
                    help: "Author of wish is it's first donee. You can add more donees and create shared wish. Other donees can only add more donors from theirs friends."
                  },
                  donors: {
                    help: "Add potentional donors here. These are some of your friends, who will see this wish and can fullfill it. Nonactive items are already in donees, so You can not choose them as donors."
                  },
                  unused_connections: {
                    header: "Unused",
                    help: "Your friends, which can not see this wish. If there are none, You maybe do not have any connection in Friends or all of them are already in other blocks."
                  }  
                },
                added: "Wish '%{title}' was successfully created.",
                not_added: "Wish '%{title}' was not created.",
                updated: "Wish '%{title}' was successfully updated.",
                not_updated: "Wish '%{title}' was not updated.",
                deleted: "Wish '%{title}' was successfully deleted.",
                not_deleted: "Wish '%{title}' was not deleted.",
                delete: {
                    confirm: {
                        message: "Really delete?"
                    }
                }    
            }

        },

        from_donee: {
            views: {
                index: {
                    header: "My wishes"
                },
                list: {
                    none: "You do not have any wish, add some!"
                },
                show: {
                    name_for_author_connection: "Author of the wish",
                    donors: {
                        count: "Total: %{total} / Yours: %{owns}"
                    }
                },
                updated: "Potentional donor list for '%{title}' was successfully updated.",
                not_updated: "Wish '%{title}' was not updated.",
                deleted: "You were removed from donees of '%{title}'.",
                not_deleted: "You were not removed from donees of '%{title}'",
                delete: {
                    confirm: {
                        message: "Really delete?"
                    }
                }    
            }

        },
        from_donor: {
            views: {
                index: {
                    header: "Can fullfill"
                },
                show: {
                    donees_list_header: "Donees"
                }
            }
        }    

    }
}}
