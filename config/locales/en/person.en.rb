{:cs => {
    :activerecord => {
        :models => {
            :person => {
                :one => "Person",
                :other => "People"
            }
        },
        :attributes => {
            :person => {
                :name => "Name",
                :address => "Address"
            }
        },
        :errors => {
            :models => {
                :person => {
                    :attributes => {
                        :name => {
                            :too_short => "This name is too short"
                        }
                    }
                }
            }
        }

    },

    :person => {
        :views => {
            :header => "My wishes"
            }
        }
    }
}
