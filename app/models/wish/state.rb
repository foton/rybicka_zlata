# frozen_string_literal: true

module Wish::State
  STATE_AVAILABLE = 0
  STATE_CALL_FOR_CO_DONORS = 1
  STATE_RESERVED = 5
  STATE_GIFTED = 9
  STATE_FULFILLED = 10

  def available_actions_for(user)
    @available_users_actions = {} unless defined?(@available_users_actions)

    if @available_users_actions[user].nil?
      @available_users_actions[user] = if user.donee_of?(self)
                                         actions_for_donee(user)
                                       elsif user.donor_of?(self)
                                         actions_for_donor(user)
                                       else
                                         []
                                       end
    end
    @available_users_actions[user]
  end

  def available_state_actions_for(user)
    (available_actions_for(user) - %i[show edit delete])
  end

  def booked_by?(user)
    booked_by_id == user.id
  end

  def called_by?(user)
    called_for_co_donors_by_id == user.id
  end

  def available?
    state == STATE_AVAILABLE
  end

  def book!(user)
    return unless user.donor_of?(self)

    self.state = STATE_RESERVED
    self.booked_by_user = user
    self.called_for_co_donors_by_id = nil
    @available_users_actions = {}
    I18n.t('wishes.actions.book.message', wish_title: title, user_name: user.name)
  end

  def booked?
    state == STATE_RESERVED
  end

  def unbook!(user)
    if booked_by?(user)
      self.state = STATE_AVAILABLE
      self.booked_by_id = nil
      @available_users_actions = {}
      I18n.t('wishes.actions.unbook.message', wish_title: title, user_name: user.name)
    end
  end

  def call_for_co_donors!(user)
    if user.donor_of?(self)
      self.state = STATE_CALL_FOR_CO_DONORS
      self.called_for_co_donors_by_id = user.id
      @available_users_actions = {}
      I18n.t('wishes.actions.call_for_co_donors.message', wish_title: title, user_name: user.name)
    end
  end

  def withdraw_call!(user)
    if called_by?(user)
      self.state = STATE_AVAILABLE
      self.called_for_co_donors_by_id = nil
      @available_users_actions = {}
      I18n.t('wishes.actions.withdraw_call.message', wish_title: title, user_name: user.name)
    end
  end

  def call_for_co_donors?
    state == STATE_CALL_FOR_CO_DONORS
  end

  def gifted!(user)
    if booked_by?(user)
      self.state = STATE_GIFTED
      # self.booked_by_user=user
      @available_users_actions = {}
      I18n.t('wishes.actions.gifted.message', wish_title: title, user_name: user.name)
    end
  end

  def gifted?
    state == STATE_GIFTED
  end

  def fulfilled!(user)
    if user.donee_of?(self)
      self.state = STATE_FULFILLED
      @available_users_actions = {}
      donor_links.destroy_all # they are no longer needed
      I18n.t('wishes.actions.fulfilled.message', wish_title: title)
    end
  end

  def fulfilled?
    state == STATE_FULFILLED
  end

  private

  def actions_for_donee(_user)
    if gifted?
      [:fulfilled]
    elsif fulfilled?
      []
    else
      %i[show edit delete fulfilled]
    end
  end

  def actions_for_donor(user)
    if available?
      %i[show book call_for_co_donors]
    elsif booked?
      (booked_by?(user) ? %i[show unbook gifted] : [])
    elsif call_for_co_donors?
      (called_by?(user) ? %i[show withdraw_call book] : %i[show book])
    elsif gifted? || fulfilled?
      []
    else
      []
    end
  end
end
