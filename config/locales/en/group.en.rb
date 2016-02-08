{en: {
    activerecord: {
        models: {
            group: {
                one: "Group",
                other: "Groups"
            }
        },
        attributes: {
            group: {
                name: "Name"
            }
        },
        errors: {
            models: {
                group: {
                    attributes: {
                        name: {
                            too_short: "This Name is too short"
                        }
                    }
                }
            }
        }

    },

    group: {
        views: {
            header: "Groups",
            add: { 
              name: "Name"
            }
        }
    }
}}