module Wish::State

  STATE_AVAILABLE=0
  STATE_CALL_FOR_CO_DONORS=1
  STATE_RESERVED=5
  STATE_GIFTED=9
  STATE_FULFILLED=10
  
  def available_actions_for(user)
    if user.is_donee_of?(self)
      actions_for_donee(user)
    elsif user.is_donor_of?(self)
      actions_for_donor(user)
    else
      []
    end  
  end  

  def booked_by?(user)
    self.booked_by_id == user.id
  end  

  def available?
    self.state == STATE_AVAILABLE
  end  


  def book!(user)
    if user.is_donor_of?(self)
      self.state= STATE_RESERVED
      self.booked_by_user=user
      I18n.t("wish.actions.book.message", wish_title: self.title, user_name: user.name)
    end  
  end  

  def booked?
    self.state == STATE_RESERVED
  end  

  def unbook!(user)
    if self.booked_by?(user)
      self.state= STATE_AVAILABLE
      self.booked_by_id=nil
      I18n.t("wish.actions.unbook.message", wish_title: self.title)
    end  
  end  

  def call_for_co_donors!(user)
    if user.is_donor_of?(self)
      self.state= STATE_CALL_FOR_CO_DONORS
      self.booked_by_user=user
      I18n.t("wish.actions.call_for_co_donors.message", wish_title: self.title, user_name: user.name)
    end  
  end  

  def call_for_co_donors?
    self.state == STATE_CALL_FOR_CO_DONORS
  end  

  def gifted!(user)
    if self.booked_by?(user)
      self.state= STATE_GIFTED
      #self.booked_by_user=user
      I18n.t("wish.actions.gifted.message", wish_title: self.title, user_name: user.name)
    end  
  end  

  def gifted?
    self.state == STATE_GIFTED
  end  

  def fullfilled!(user)
    if user.is_donee_of?(self)
      self.state= STATE_FULFILLED
      I18n.t("wish.actions.fullfilled.message", wish_title: self.title)
    end
  end  

  def fullfilled?
    self.state == STATE_FULFILLED
  end  

  private

    def actions_for_donee(user)
      if self.gifted?
        [:fullfilled]  
      elsif self.fullfilled?
        []  
      else  
        [:show, :edit, :delete, :fullfilled]  
      end
    end

    def actions_for_donor(user)
      if self.available?
        [:show, :book, :call_for_co_donors]
      elsif self.booked?
        (self.booked_by?(user) ? [:show, :unbook, :gifted] : [])
      elsif self.call_for_co_donors?
        (self.booked_by?(user) ? [:show, :unbook, :book] :  [:show, :book])
      elsif (self.gifted? || self.fullfilled?)
        []
      else 
        []
      end
    end


end  
