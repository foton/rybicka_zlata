# frozen_string_literal: true

# == Schema Information
#
# Table name: donor_links
#
#  id            :integer          not null, primary key
#  role          :integer          default(0), not null
#  connection_id :integer          not null
#  wish_id       :integer          not null
#
# Connects wish with connections. `Connection.friend` then became donors for wish.
class DonorLink < ApplicationRecord
  belongs_to :connection, inverse_of: :donor_links
  belongs_to :wish, inverse_of: :donor_links

  ROLE_AS_POTENCIAL_DONOR = 0
  ROLE_AS_REAL_DONOR = 1

  delegate :user, to: :connection

  scope :for_wish, ->(wish) { where(wish_id: wish.id) }
  scope :for_connection, ->(conn) { where(connection_id: conn.id) }
end
