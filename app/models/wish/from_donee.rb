# frozen_string_literal: true

# == Schema Information
#
# Table name: wishes
#
#  id                         :integer          not null, primary key
#  description                :text
#  state                      :integer          default(0), not null
#  title                      :string           not null
#  updated_by_donee_at        :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#  author_id                  :integer          not null
#  booked_by_id               :integer
#  called_for_co_donors_by_id :integer
#  updated_by_id              :bigint
#
class Wish::FromDonee < Wish
  self.table_name = 'wishes'

  before_validation :fill_connections_from_ids
  before_save :set_updated_by_donee_at

  # can only add/remove its own connections
  def merge_donor_conn_ids(conn_ids, user)
    conn_ids = [] unless conn_ids.is_a?(Array)

    user_conn_ids = user.connections.pluck(:id)
    conn_ids_to_add = conn_ids & user_conn_ids
    conn_ids_to_remove = user_conn_ids - conn_ids_to_add

    new_donor_conn_ids = (donor_conn_ids + conn_ids_to_add - conn_ids_to_remove).uniq
    @donors_changed = (new_donor_conn_ids.sort != @donor_conn_ids.sort)
    @donor_conn_ids = new_donor_conn_ids
    fill_connections_from_ids
  end

  def donee_conn_ids=(conn_ids)
    # silently ignoring
  end

  def destroy(by_user)
    if author == by_user
      Wish.find(id).destroy
      true
    elsif (user_conn_ids = donee_connections.where(friend_id: by_user.id).collect(&:id)).present?
      # somebody from donees: just remove user from donees
      donee_links.where(connection_id: user_conn_ids).delete_all
      true
    else
      false
    end
  end

  private

  def fill_connections_from_ids
    self.donor_connections = ::Connection.find(donor_conn_ids.compact.uniq).to_a
    @donor_user_ids = nil
    @donor_users = nil

    ensure_donors_are_only_from_current_donees
  end

  def set_updated_by_donee_at
    self.updated_by_donee_at = Time.current if changed?
  end

  def ensure_donors_are_only_from_current_donees
    connection_ids_of_current_donees = ::Connection.where(owner_id: donee_user_ids).pluck(:id)
    dls_to_delete = donor_links.where.not(connection_id: connection_ids_of_current_donees)
    dls_to_delete.destroy_all
  end
end
