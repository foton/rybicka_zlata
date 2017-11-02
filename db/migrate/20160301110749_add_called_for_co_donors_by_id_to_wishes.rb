# frozen_string_literal: true

class AddCalledForCoDonorsByIdToWishes < ActiveRecord::Migration
  def change
    add_column :wishes, :called_for_co_donors_by_id, :integer, null: true, index: true
    add_foreign_key :wishes, :users, column: :called_for_co_donors_by_id, primary_key: :id
  end
end
