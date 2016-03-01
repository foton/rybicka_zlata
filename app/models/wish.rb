class Wish < ActiveRecord::Base
  belongs_to :author, class_name:"User"
  belongs_to :booked_by_user, class_name:"User", foreign_key: "booked_by_id"
  belongs_to :called_for_co_donors_by_user, class_name:"User", foreign_key: "called_for_co_donors_by_id"
  
  has_many :donor_links, dependent: :delete_all, inverse_of: :wish
  has_many :donor_connections, through: :donor_links, source: :connection
  has_many :donee_links, dependent: :delete_all, inverse_of: :wish
  has_many :donee_connections, through: :donee_links, source: :connection

  validates :title, presence: true
  validates :author, presence: true
  
  validate :no_same_donor_and_donee
  validate :validate_booked_by
  validate :validate_called_for_co_donors
  
  include Wish::State

  public

  scope :not_fullfilled, ->{ where.not( state: Wish::State::STATE_FULFILLED) }

  def available_donor_connections_from(connections)
    emails_of_donees=(donee_connections.collect {|c| c.email}).uniq.compact
    user_ids_of_donees=(donee_connections.collect {|c| c.friend_id}).uniq.compact
 
    #(connections-connections.where(email: emails_of_donees)-connections.where(friend_id: user_ids_of_donees))
    (connections.reject {|conn| (emails_of_donees.include?(conn.email) || user_ids_of_donees.include?(conn.friend_id)) } )
  end  

  def description_shortened
    if description.size > 100
      description[0..95].gsub(/ \S*\z/,"")+" ..."
    else
      description 
    end 
  end  

  def is_author?(user)
    author_id == user.id
  end  

  def is_donor?(user)
    donor_user_ids.include?(user.id)
  end  

  def is_donee?(user)
    is_author?(user) || donee_user_ids.include?(user.id)
  end  

  private
    def donor_user_ids
      @donor_user_ids ||=(donor_connections.collect {|conn| conn.friend_id})
    end  

    def donee_user_ids
      @donee_user_ids ||=(donee_connections.collect {|conn| conn.friend_id})
    end  

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


    def validate_booked_by
      if [STATE_RESERVED, STATE_GIFTED].include?(self.state)
        if self.booked_by_user.blank?
          self.errors.add(:booked_by_id, I18n.t("wish.errors.must_have_booking_user"))
        else    
          bu=self.booked_by_user
          self.errors.add(:booked_by_id, I18n.t("wish.errors.cannot_be_booked_by_donee")) if self.is_donee?(bu)
        end    
      elsif STATE_AVAILABLE == self.state
        self.errors.add(:booked_by_id, I18n.t("wish.errors.cannot_be_booked_in_this_state")) if self.booked_by_user.present?
      else
        #wish can be fullfiled from outside, booked_id CAN be present
      end  
    end  

    def validate_called_for_co_donors
      if [STATE_CALL_FOR_CO_DONORS].include?(self.state)
        if self.called_for_co_donors_by_user.blank?
          self.errors.add(:called_for_co_donors_by_id, I18n.t("wish.errors.must_have_calling_by_user"))
        else    
          cu=self.called_for_co_donors_by_user
          self.errors.add(:called_for_co_donors_by_id, I18n.t("wish.errors.donne_cannot_call_for_co_donors")) if self.is_donee?(cu)
        end    
      elsif STATE_AVAILABLE == self.state
        self.errors.add(:called_for_co_donors_by_id, I18n.t("wish.errors.cannot_be_called_in_this_state")) if self.called_for_co_donors_by_user.present?
      else
        #others states may or may not have filled in called_for_co_donors_by_id
      end  
    end  
end
