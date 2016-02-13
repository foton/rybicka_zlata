# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160213124256) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", force: :cascade do |t|
    t.string  "name",      null: false
    t.string  "email",     null: false
    t.integer "friend_id"
    t.integer "owner_id"
  end

  add_index "connections", ["email"], name: "index_connections_on_email", using: :btree
  add_index "connections", ["friend_id"], name: "index_connections_on_friend_id", using: :btree
  add_index "connections", ["owner_id"], name: "index_connections_on_owner_id", using: :btree

  create_table "connections_groups", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "connection_id"
  end

  add_index "connections_groups", ["connection_id"], name: "index_connections_groups_on_connection_id", using: :btree
  add_index "connections_groups", ["group_id"], name: "index_connections_groups_on_group_id", using: :btree

  create_table "donee_links", id: false, force: :cascade do |t|
    t.integer "wish_id",       null: false
    t.integer "connection_id", null: false
  end

  add_index "donee_links", ["connection_id"], name: "index_donee_links_on_connection_id", using: :btree
  add_index "donee_links", ["wish_id", "connection_id"], name: "donee_wish_conn_index", unique: true, using: :btree
  add_index "donee_links", ["wish_id"], name: "index_donee_links_on_wish_id", using: :btree

  create_table "donor_links", id: false, force: :cascade do |t|
    t.integer "wish_id",                   null: false
    t.integer "connection_id",             null: false
    t.integer "role",          default: 0, null: false
  end

  add_index "donor_links", ["connection_id"], name: "index_donor_links_on_connection_id", using: :btree
  add_index "donor_links", ["role"], name: "index_donor_links_on_role", using: :btree
  add_index "donor_links", ["wish_id", "connection_id"], name: "donor_wish_conn_index", unique: true, using: :btree
  add_index "donor_links", ["wish_id"], name: "index_donor_links_on_wish_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string  "name",    null: false
    t.integer "user_id", null: false
  end

  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.string  "provider", default: "", null: false
    t.string  "uid",      default: "", null: false
    t.integer "user_id"
    t.string  "email"
  end

  add_index "identities", ["email"], name: "index_identities_on_email", using: :btree
  add_index "identities", ["provider", "uid"], name: "oauth_index", unique: true, using: :btree
  add_index "identities", ["provider"], name: "index_identities_on_provider", using: :btree
  add_index "identities", ["uid"], name: "index_identities_on_uid", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                            default: "",       null: false
    t.string   "encrypted_password",               default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "locale",                 limit: 5, default: "cs",     null: false
    t.string   "time_zone",                        default: "Prague", null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wishes", force: :cascade do |t|
    t.string   "title",                           null: false
    t.text     "description"
    t.integer  "state",               default: 0, null: false
    t.integer  "author_id",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "updated_by_donee_at"
  end

  add_index "wishes", ["author_id"], name: "index_wishes_on_author_id", using: :btree

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
end
