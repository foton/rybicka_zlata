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

    wish: {
        from_donee: {
            views: {
                index: {
                    header: "My wishes"
                }
            }

        },
        from_donor: {
            views: {
                index: {
                    header: "Can fulfill"
                }
            }
        }    

    }

}}
