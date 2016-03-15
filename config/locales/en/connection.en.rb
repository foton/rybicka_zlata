{en: {
    activerecord: {
        models: {
            connection: {
                one: "Connection",
                other: "Connections"
            }
        },
        attributes: {
            connection: {
                name: "Name",
                email: "E-mail"
            }
        },
        errors: {
            models: {
                connection: {
                    attributes: {
                        name: {
                            too_short: "This name is too short"
                        }
                    }
                }
            }
        }

    },

    connections: {
        base_cover_name: "Author of wish",
        friend_deleted: "deleted",
        actions: {
          new: { 
            button: "Add"
          },
          save: {
            button: "Save"
          },
          edit: {
            button: "Edit"
          },
          delete: {
            button: "Delete"
          }

        },        
        views: {
            header: "Connections",
            help: "You share/show your wishes with other users through connections (donees/donors). If email address is registerd by another user, You will see his/hers account name in square brackets. If there is '???', it means that i Rybička Zlatá there is no user with it. But when he/she will register, connection become usefull instantly. So no-user contacts are good for future.",
            add: {
                name: "Name",
                email: "E-mail"
            },
            added: "Connection '%{fullname}' was successfully added.",
            not_added: "Connection '%{fullname}' was not added.",
            updated: "Connection '%{fullname}' was successfully updated.",
            not_updated: "Connection '%{fullname}' was not updated.",
            deleted: "Connection '%{fullname}' was successfully deleted.",
            not_deleted: "Connection '%{fullname}' was not deleted.",
            list: {
                header: "Connections list",
                none: "No connections yet"
            },
            delete: {
                confirm: {
                    message: "Really delete?"
                }
            }            
        }
    }
}}
