{:en => {
    :activerecord => {
        :models => {
            :wish => {
                :one => "Wish",
                :other => "Wishes"
            }
        },
        :attributes => {
            :wish => {
                :title => "Title",
                :comment => "Description"
            }
        },
        :errors => {
            :models => {
                :wish => {
                    :attributes => {
                        :title => {
                            :too_short => "This Tile is minimized too much"
                        }
                    }
                }
            }
        }

    },

    :wish => {
        :views => {
            :my => {
                :header => "My wishes"
            },
            :theirs => {
                :header => "Can fullfill"
            }

        }
    }
}}
