#this class connects wish with donors
class DonorLink < ActiveRecord::Base
	belongs_to :connection
	belongs_to :wish

	ROLE_AS_POTENCIAL_DONOR=0
	ROLE_AS_REAL_DONOR=1

	def user
		connection.user
	end	
end