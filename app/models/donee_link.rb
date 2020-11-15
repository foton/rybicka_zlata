# frozen_string_literal: true

# == Schema Information
#
# Table name: donee_links
#
#  id            :integer          not null, primary key
#  connection_id :integer          not null
#  wish_id       :integer          not null
#
class DoneeLink < ApplicationRecord
  belongs_to :connection, inverse_of: :donee_links
  belongs_to :wish, inverse_of: :donee_links

  delegate :user, to: :connection

  scope :for_wish, ->(wish) { where(wish_id: wish.id) }
  scope :for_connection, ->(conn) { where(connection_id: conn.id) }
end
