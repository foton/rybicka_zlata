# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_12_165443) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.integer "friend_id"
    t.integer "owner_id"
    t.index ["email"], name: "index_connections_on_email"
    t.index ["friend_id"], name: "index_connections_on_friend_id"
    t.index ["owner_id"], name: "index_connections_on_owner_id"
  end

  create_table "connections_groups", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "connection_id"
    t.index ["connection_id"], name: "index_connections_groups_on_connection_id"
    t.index ["group_id"], name: "index_connections_groups_on_group_id"
  end

  create_table "donee_links", id: :serial, force: :cascade do |t|
    t.integer "wish_id", null: false
    t.integer "connection_id", null: false
    t.index ["connection_id"], name: "index_donee_links_on_connection_id"
    t.index ["wish_id", "connection_id"], name: "donee_wish_conn_index", unique: true
    t.index ["wish_id"], name: "index_donee_links_on_wish_id"
  end

  create_table "donor_links", id: :serial, force: :cascade do |t|
    t.integer "wish_id", null: false
    t.integer "connection_id", null: false
    t.integer "role", default: 0, null: false
    t.index ["connection_id"], name: "index_donor_links_on_connection_id"
    t.index ["role"], name: "index_donor_links_on_role"
    t.index ["wish_id", "connection_id"], name: "donor_wish_conn_index", unique: true
    t.index ["wish_id"], name: "index_donor_links_on_wish_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.string "provider", default: "", null: false
    t.string "uid", default: "", null: false
    t.integer "user_id"
    t.string "email"
    t.index ["email"], name: "index_identities_on_email"
    t.index ["provider", "uid"], name: "oauth_index", unique: true
    t.index ["provider"], name: "index_identities_on_provider"
    t.index ["uid"], name: "index_identities_on_uid"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.string "key", null: false
    t.string "group_type"
    t.bigint "group_id"
    t.integer "group_owner_id"
    t.string "notifier_type"
    t.bigint "notifier_id"
    t.text "parameters"
    t.datetime "opened_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_owner_id"], name: "index_notifications_on_group_owner_id"
    t.index ["group_type", "group_id"], name: "index_notifications_on_group_type_and_group_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["notifier_type", "notifier_id"], name: "index_notifications_on_notifier_type_and_notifier_id"
    t.index ["target_type", "target_id"], name: "index_notifications_on_target_type_and_target_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.boolean "show_to_anybody", default: false
    t.bigint "author_id"
    t.bigint "wish_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["wish_id"], name: "index_posts_on_wish_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.string "key", null: false
    t.boolean "subscribing", default: true, null: false
    t.boolean "subscribing_to_email", default: true, null: false
    t.datetime "subscribed_at"
    t.datetime "unsubscribed_at"
    t.datetime "subscribed_to_email_at"
    t.datetime "unsubscribed_to_email_at"
    t.text "optional_targets"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_subscriptions_on_key"
    t.index ["target_type", "target_id", "key"], name: "index_subscriptions_on_target_type_and_target_id_and_key", unique: true
    t.index ["target_type", "target_id"], name: "index_subscriptions_on_target_type_and_target_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale", limit: 5, default: "cs", null: false
    t.string "time_zone", default: "Prague", null: false
    t.string "name"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "body_height", default: "??"
    t.string "body_weight", default: "??"
    t.string "tshirt_size", default: "??"
    t.string "trousers_waist_size", default: "??"
    t.string "trousers_leg_size", default: "??"
    t.string "shoes_size", default: "EU/UK/US??"
    t.text "other_sizes_and_dimensions", default: ""
    t.text "likes", default: ":-)"
    t.text "dislikes", default: ":-("
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wishes", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "state", default: 0, null: false
    t.integer "author_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "updated_by_donee_at"
    t.integer "booked_by_id"
    t.integer "called_for_co_donors_by_id"
    t.bigint "updated_by_id"
    t.index ["author_id"], name: "index_wishes_on_author_id"
    t.index ["updated_by_id"], name: "index_wishes_on_updated_by_id"
  end

  add_foreign_key "connections", "users", column: "friend_id"
  add_foreign_key "connections", "users", column: "owner_id"
  add_foreign_key "connections_groups", "connections"
  add_foreign_key "connections_groups", "groups"
  add_foreign_key "donee_links", "connections"
  add_foreign_key "donee_links", "wishes"
  add_foreign_key "donor_links", "connections"
  add_foreign_key "donor_links", "wishes"
  add_foreign_key "groups", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "wishes", "users", column: "author_id"
  add_foreign_key "wishes", "users", column: "booked_by_id"
  add_foreign_key "wishes", "users", column: "called_for_co_donors_by_id"
  add_foreign_key "wishes", "users", column: "updated_by_id"
end
