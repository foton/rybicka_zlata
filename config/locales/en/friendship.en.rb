{:en => {
    :activerecord => {
        :models => {
            :friendship => {
                :one => "Friendship",
                :other => "Friendships"
            }
        },
        :attributes => {
            :friendship => {
                :name => "Name",
                :address => "Address"
            }
        },
        :errors => {
            :models => {
                :friendship => {
                    :attributes => {
                        :name => {
                            :too_short => "This name is too short"
                        }
                    }
                }
            }
        }

    },

    :friendship => {
        :views => {
            :header => "Friendships"
            }
        }
    }
}
