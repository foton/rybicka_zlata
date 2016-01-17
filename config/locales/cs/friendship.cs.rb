{:cs => {
    :activerecord => {
        :models => {
            :friendship => {
                :one => "Přátelství",
                :other => "Přátelství"
            }
        },
        :attributes => {
            :friendship => {
                :name => "Jméno",
                :address => "Adresa"
            }
        },
        :errors => {
            :models => {
                :friendship => {
                    :attributes => {
                        :name => {
                            :too_short => "Tohle Jméno je minimální až moc"
                        }
                    }
                }
            }
        }

    },

    :friendship => {
        :views => {
            :header => "Přátelství"
            }
        }
    }
}
