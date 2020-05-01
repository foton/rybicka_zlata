# frozen_string_literal: true

# author can manage wish, donees and donors
class Wish::FromAuthor < Wish::FromDonee
  self.table_name = 'wishes'

  def donee_conn_ids=(ids)
    new_ids = (author.present? ? [author.base_connection.id] + ids : ids).uniq.compact.sort
    @donees_changed = (donee_conn_ids.sort != new_ids)
    @donee_conn_ids = new_ids
  end

  def destroy(by_user = author)
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
    self.donee_connections = ::Connection.find(donee_conn_ids).to_a
    @donee_user_ids = nil

    super
  end
end
