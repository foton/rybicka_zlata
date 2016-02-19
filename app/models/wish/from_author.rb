#author can manage wish, donees and donors
class Wish::FromAuthor < Wish::FromDonee
	self.table_name = 'wishes'

	attr_accessor :donee_conn_ids

	private
	   def fill_connections_from_ids
	   	super

    	@donee_conn_ids=[] unless @donee_conn_ids.kind_of?(Array)
    	@donee_conn_ids << author.base_connection.id if author
    	#TODO: only current donee can add his/her connections as other donees
    	self.donee_connections=::Connection.find(@donee_conn_ids.compact.uniq).to_a
    end	
end
