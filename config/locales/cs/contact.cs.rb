#encoding: utf-8
{:cs => {
    :activerecord => {
        :models => {
            :contact => {
                :one => "Kontakt",
                :other => "Kontakty"
            },
            :friend_contact => {
                :one => "Známý",
                :other => "Známí"
            }
        },
        :attributes => {
            :contact => {
                :address => "Kontaktní adresa"
            },
            :friend_contact => {
                :name => "Název kontaktu",
                :address => "Kontaktní adresa"
            }

        },
        :errors => {
            :models => {
            }
        }

    },
    :friend_contact => {
        :add_friend_button => "Přidat známého",
        :create => "Přidat",
        :created_successfully => "Kontakt '%{name}' byl úspešně přidán.",
        :editing => "Editace kontaktu '%{name}'",
        :updated_successfully => "Kontakt '%{name}' byl úspešně aktualizován." ,
        :delete_confirm =>  "Opravdu vymazat kontakt '%{name}'?"
    }
}}
