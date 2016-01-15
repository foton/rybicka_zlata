{:cs => {
    :activerecord => {
        :models => {
            :person => {
                :one => "Člověk",
                :other => "Lidé"
            }
        },
        :attributes => {
            :person => {
                :name => "Jméno",
                :address => "Adresa"
            }
        },
        :errors => {
            :models => {
                :person => {
                    :attributes => {
                        :name => {
                            :too_short => "Tohle Jméno je minimální až moc"
                        }
                    }
                }
            }
        }

    },

    :person => {
        :views => {
            :header => "Má přání"
            }
        }
    }
}
