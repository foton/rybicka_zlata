# frozen_string_literal: true

module WishesHelper
  def path_to_wish_action_for_user(action, user, wish = nil, params = {})
    return new_user_author_wish_path(user) if action == :new
    return '' if wish.blank?

    if user.is_author_of?(wish)
      base_path = 'user_author_wish_path'
    elsif user.is_donee_of?(wish)
      base_path = 'user_my_wish_path'
    elsif user.is_donor_of?(wish)
      base_path = 'user_others_wish_path'
    else
      return ''
    end

    prefix = case action.to_sym
             when :edit
               'edit_'
             else
               ''
             end

    send("#{prefix}#{base_path}", user, wish, params)
  end

  # def button_to_wish_action(action, user, wish=nil, remote=false, params={})
  #   tag_to_object_action(:button, action, user, wish, remote, params)
  # end

  # def link_to_wish_action(action, user, wish=nil, remote=false, params={})
  #   tag_to_object_action(:a, action, user, wish, remote, params)
  # end

  def class_for_state(wish, user = current_user)
    if wish.available?
      'wish_available'
    elsif wish.booked?
      wish.booked_by?(user) ? 'wish_me_as_donor' : 'wish_reserved'
    elsif wish.call_for_co_donors?
      wish.called_by?(user) ? 'wish_me_as_donor' : 'wish_call-for-co-donors'
    elsif wish.gifted?
      wish.booked_by?(user) ? 'wish_me_as_donor' : 'wish_gifted'
    elsif wish.fulfilled?
      'wish_fulfilled'
    else
      ''
    end
  end

  def donor_class_for_state(wish, user = current_user)
    if user.is_donor_of?(wish)
      class_for_state(wish, user)
    else
      ''
    end
  end

  def donor_infos_for(wish, user = current_user)
    if wish.call_for_co_donors? && user.is_donor_of?(wish)
      raw '<span class="donor_infos">' + I18n.t('wishes.actions.call_for_co_donors.notice', user_name: wish.called_for_co_donors_by_user.name) + '</span>'
    end
  end

  def icon_of_wish_sharing(wish)
    if wish.is_shared?
      icon = 'group'
      tooltip = I18n.t('wishes.shared_icon_tooltip.shared')
    else
      icon = 'person'
      tooltip = I18n.t('wishes.shared_icon_tooltip.personal')
    end
    w_id = anchor_for(wish) + '_shared_icon'
    raw "<i class=\"material-icons shared-wish-icon\" id=\"#{w_id}\" >#{icon}</i><span class=\"mdl-tooltip\" for=\"#{w_id}\" >#{tooltip}</span>"
  end
end
