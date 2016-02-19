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

    connection: {
        base_cover_name: "Author of wish",
        friend_deleted: "deleted",
        views: {
            header: "Friends",
            add: {
                name: "Name",
                email: "E-mail"
            },
            added: "Friend '%{fullname}' was successfully added.",
            not_added: "Friend '%{fullname}' was not added.",
            updated: "Friend '%{fullname}' was successfully updated.",
            not_updated: "Friend '%{fullname}' was not updated.",
            deleted: "Friend '%{fullname}' was successfully deleted.",
            not_deleted: "Friend '%{fullname}' was not deleted.",
            list: {
                header: "Friends list",
                none: "No friends yet"
            },
            delete: {
                confirm: {
                    message: "Really delete?"
                }
            }            
        }
    }
}}
