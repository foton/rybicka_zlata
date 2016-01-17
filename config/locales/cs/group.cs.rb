{:cs => {
    :activerecord => {
        :models => {
            :group => {
                :one => "Skupina",
                :other => "Skupiny"
            }
        },
        :attributes => {
            :group => {
                :name => "Jméno"
            }
        },
        :errors => {
            :models => {
                :group => {
                    :attributes => {
                        :name => {
                            :too_short => "Tohle Jméno je minimální až moc"
                        }
                    }
                }
            }
        }

    },

    :group => {
        :views => {
            :header => "Skupiny"
            }
        }
    }
}