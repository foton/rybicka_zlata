# frozen_string_literal: true

# donee can manage wish and donors (not donees)
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

    @donor_conn_ids ||= donor_connections.pluck(:id)
    @donor_conn_ids += conn_ids_to_add
    @donor_conn_ids -= conn_ids_to_remove
    @donor_conn_ids.uniq!
    @donor_conn_ids
  end

  attr_reader :donor_conn_ids

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
    @donor_conn_ids = [] unless @donor_conn_ids.is_a?(Array)
    self.donor_connections = ::Connection.find(@donor_conn_ids.compact.uniq).to_a
    @donor_user_ids = nil
  end

  def set_updated_by_donee_at
    self.updated_by_donee_at = Time.zone.now if changed?
  end
end
