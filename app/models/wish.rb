class Wish < ActiveRecord::Base
  belongs_to :author, class_name:"User"
  has_many :donor_links, dependent: :delete_all, inverse_of: :wish
  has_many :donor_connections, through: :donor_links, source: :connection
  has_many :donee_links, dependent: :delete_all, inverse_of: :wish
  has_many :donee_connections, through: :donee_links, source: :connection

  STATE_AVAILABLE=0
  STATE_CALL_FOR_CO_DONORS=1
  STATE_RESERVED=5
  STATE_ACQUIRED=9
  STATE_FULFILLED=10

  validates :title, presence: true
  validates :author, presence: true
  validate :no_same_donor_and_donee

  def available_donor_connections_from(connections)
    emails_of_donees=donee_connections.collect {|c| c.email}
    user_ids_of_donees=donee_connections.collect {|c| c.friend_id}
 
    (connections-connections.where(email: emails_of_donees)-connections.where(friend_id: user_ids_of_donees))
  end  

  private
    #wish should not have the same USER or CONNECTION.EMAIL as donee and donor
    def no_same_donor_and_donee
      donor_conns=donor_connections.to_a
      donee_conns=donee_connections.to_a

      #first check for same connection 
      in_both=donor_conns & donee_conns
      if in_both.present?
        add_same_donor_and_donee_error(I18n.t("wish.errors.same_donor_and_donee.by_connection", conn_fullname: in_both.first.fullname)) 
      else  
        #check for connection with same email (cann be dubled with another name)
        donor_emails=donor_conns.collect{|c| c.email}
        donee_emails=donee_conns.collect{|c| c.email}
        in_both=donor_emails & donee_emails
        if in_both.present?      
          add_same_donor_and_donee_error(I18n.t("wish.errors.same_donor_and_donee.by_email", email: in_both.first))
        else  
          #check for identical user directly (can have many emails)
          donor_user_ids=(donor_conns.collect{|c| c.friend_id}).compact
          donee_user_ids=(donee_conns.collect{|c| c.friend_id}).compact
          in_both=donor_user_ids & donee_user_ids
          if in_both.present?      
            donor_connection=(donor_conns.select{|c| c.friend_id == in_both.first}).first
            donee_connection=(donee_conns.select{|c| c.friend_id == in_both.first}).first
            add_same_donor_and_donee_error(I18n.t("wish.errors.same_donor_and_donee.by_user", donee_fullname: donee_connection.fullname, donor_fullname: donor_connection.fullname))
          end
        end
      end    
    end  

    def add_same_donor_and_donee_error(text)
      errors.add(:donor_conn_ids,text)
      errors.add(:donee_conn_ids,text)
    end  


end
