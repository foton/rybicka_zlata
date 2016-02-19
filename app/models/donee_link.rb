#this class connects wish with donees
class DoneeLink < ActiveRecord::Base
	belongs_to :connection , inverse_of: :donee_links
	belongs_to :wish , inverse_of: :donee_links

	def user
		connection.user
	end	

  scope :for_wish, -> (wish) { where(wish_id: wish.id) }
	scope :for_connection, -> (conn) { where(connection_id: conn.id) }

end