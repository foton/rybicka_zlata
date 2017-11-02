# frozen_string_literal: true

# author can manage wish, donees and donors
class Wish::FromAuthor < Wish::FromDonee
  self.table_name = 'wishes'

  attr_accessor :donee_conn_ids

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
    super

    @donee_conn_ids = [] unless @donee_conn_ids.is_a?(Array)
    @donee_conn_ids << author.base_connection.id if author
    @donee_conn_ids.uniq!
    # TODO: only current donee can add his/her connections as other donees
    self.donee_connections = ::Connection.find(@donee_conn_ids.compact.uniq).to_a
    @donee_user_ids = nil

    ensure_no_connections_from_ex_donees
 end
end
