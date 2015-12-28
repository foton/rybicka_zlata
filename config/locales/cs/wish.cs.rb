{:cs => {
    :activerecord => {
        :models => {
            :wish => {
                :one => "Přání",
                :other => "Přání"
            }
        },
        :attributes => {
            :wish => {
                :title => "Titulek",
                :comment => "Popis"
            }
        },
        :errors => {
            :models => {
                :wish => {
                    :attributes => {
                        :title => {
                            :too_short => "Tenhle Titulek je minimální až moc"
                        }
                    }
                }
            }
        }

    },

    :wish => {
        :views => {
            :my_wishes => {
                :header => "Moje přání"
            },
            :others_wishes => {
                :header => "Mohu splnit"
            }

        }
    }
}}
