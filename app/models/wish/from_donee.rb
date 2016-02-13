class Wish::FromDonee < Wish
	self.table_name = 'wishes'

  before_validation :fill_connections_from_ids
  before_save :set_updated_by_donee_at

  attr_accessor :donor_conn_ids
  attr_accessor :donee_conn_ids

  private
    def fill_connections_from_ids
    	@donee_conn_ids=[] unless @donee_conn_ids.kind_of?(Array)
    	@donee_conn_ids << author.base_connection.id if author

    	#TODO: only current donee can add his/her connections as other donees
    	self.donee_connections=::Connection.find(@donee_conn_ids).to_a
    	#TODO: only connection from all donnies can be added as donors
    	self.donor_connections=::Connection.find(@donor_conn_ids).to_a
    end	

    def set_updated_by_donee_at
    	self.updated_by_donee_at=Time.zone.now
    end	
end
