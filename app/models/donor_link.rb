# frozen_string_literal: true

# this class connects wish with donors
class DonorLink < ApplicationRecord
  belongs_to :connection, inverse_of: :donor_links
  belongs_to :wish, inverse_of: :donor_links

  ROLE_AS_POTENCIAL_DONOR = 0
  ROLE_AS_REAL_DONOR = 1

  delegate :user, to: :connection

  scope :for_wish, ->(wish) { where(wish_id: wish.id) }
  scope :for_connection, ->(conn) { where(connection_id: conn.id) }
end
