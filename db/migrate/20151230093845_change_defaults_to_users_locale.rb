# frozen_string_literal: true

class ChangeDefaultsToUsersLocale < ActiveRecord::Migration
  def change
    change_column :users, :locale, :string, limit: 5, null: false, default: RybickaZlata4::Application.config.i18n.default_locale
    change_column :users, :time_zone, :string, null: false, default: RybickaZlata4::Application.config.time_zone
  end
end
