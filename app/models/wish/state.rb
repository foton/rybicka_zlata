module Wish::State

  STATE_AVAILABLE=0
  STATE_CALL_FOR_CO_DONORS=1
  STATE_RESERVED=5
  STATE_GIFTED=9
  STATE_FULFILLED=10
  
  def available_actions_for(user)
    if  !defined?(@available_user_actions) || @available_user_actions.nil? 
      if user.is_donee_of?(self)
        @available_user_actions=actions_for_donee(user)
      elsif user.is_donor_of?(self)
        @available_user_actions=actions_for_donor(user)
      else
        @available_user_actions=[]
      end  
    end
    @available_user_actions
  end  

  def booked_by?(user)
    self.booked_by_id == user.id
  end  

  def called_by?(user)
    self.called_for_co_donors_by_id == user.id
  end  

  def available?
    self.state == STATE_AVAILABLE
  end  


  def book!(user)
    if user.is_donor_of?(self)
      self.state= STATE_RESERVED
      self.booked_by_user=user
      @available_user_actions=nil
      I18n.t("wishes.actions.book.message", wish_title: self.title, user_name: user.name)
    end  
  end  

  def booked?
    self.state == STATE_RESERVED
  end  

  def unbook!(user)
    if self.booked_by?(user)
      self.state= STATE_AVAILABLE
      self.booked_by_id=nil
      @available_user_actions=nil
      I18n.t("wishes.actions.unbook.message", wish_title: self.title, user_name: user.name)
    end  
  end  

  def call_for_co_donors!(user)
    if user.is_donor_of?(self)
      self.state= STATE_CALL_FOR_CO_DONORS
      self.called_for_co_donors_by_id=user.id
      @available_user_actions=nil
      I18n.t("wishes.actions.call_for_co_donors.message", wish_title: self.title, user_name: user.name)
    end  
  end  

  def withdraw_call!(user)
    if self.called_by?(user)
      self.state= STATE_AVAILABLE
      self.called_for_co_donors_by_id=nil
      @available_user_actions=nil
      I18n.t("wishes.actions.withdraw_call.message", wish_title: self.title, user_name: user.name)
    end  
  end
    
  def call_for_co_donors?
    self.state == STATE_CALL_FOR_CO_DONORS
  end  

  def gifted!(user)
    if self.booked_by?(user)
      self.state= STATE_GIFTED
      #self.booked_by_user=user
      @available_user_actions=nil
      I18n.t("wishes.actions.gifted.message", wish_title: self.title, user_name: user.name)
    end  
  end  

  def gifted?
    self.state == STATE_GIFTED
  end  

  def fulfilled!(user)
    if user.is_donee_of?(self)
      self.state= STATE_FULFILLED
      @available_user_actions=nil
      self.donor_links.destroy_all #they are no longer needed
      I18n.t("wishes.actions.fulfilled.message", wish_title: self.title)
    end
  end  

  def fulfilled?
    self.state == STATE_FULFILLED
  end  

  private

    def actions_for_donee(user)
      if self.gifted?
        [:fulfilled]  
      elsif self.fulfilled?
        []  
      else  
        [:show, :edit, :delete, :fulfilled]  
      end
    end

    def actions_for_donor(user)
      if self.available?
        [:show, :book, :call_for_co_donors]
      elsif self.booked?
        (self.booked_by?(user) ? [:show, :unbook, :gifted] : [])
      elsif self.call_for_co_donors?
        (self.called_by?(user) ? [:show, :withdraw_call, :book] :  [:show, :book])
      elsif (self.gifted? || self.fulfilled?)
        []
      else 
        []
      end
    end


end  
