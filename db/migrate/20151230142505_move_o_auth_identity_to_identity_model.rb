# frozen_string_literal: true

class MoveOAuthIdentityToIdentityModel < ActiveRecord::Migration
  def up
    create_table(:identities) do |t|
      t.string :provider, null: false, default: ''
      t.string :uid, null: false, default: ''
      t.belongs_to :user
    end

    add_index :identities, :provider
    add_index :identities, :uid
    add_index :identities, %i[provider uid], name: 'oauth_index', unique: true

    # transfer User -> Identity
    oa_users = User.where("provider IS NOT NULL AND provider <> ''")
    oa_users.each do |user|
      Identity.create!(user: user, provider: user.provider, uid: user.uid)
    end

    remove_column :users, :provider, :string
    remove_index :users, :provider
    remove_column :users, :uid, :string
    remove_index :users, :uid
  end

  def down
    add_column :users, :provider, :string
    add_index :users, :provider
    add_column :users, :uid, :string
    add_index :users, :uid

    # transfer Identity -> User
    Identity.all.each do |idnt|
      u = idnt.user
      u.provider = idnt.provider
      u.uid = idnt.uid
      u.save!
    end

    drop_table :identities
  end
end
