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
