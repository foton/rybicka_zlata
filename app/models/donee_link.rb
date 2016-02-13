#this class connects wish with donees
class DoneeLink < ActiveRecord::Base
	belongs_to :connection
	belongs_to :wish

	def user
		connection.user
	end	
end