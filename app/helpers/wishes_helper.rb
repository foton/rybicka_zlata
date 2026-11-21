# frozen_string_literal: true

module WishesHelper
  
  def path_to_wish_action_for_user(action, user, wish = nil, params = {})
    return new_user_author_wish_path(user) if action == :new
    return '' if wish.blank?

    if user.author_of?(wish)
      base_path = 'user_author_wish_path'
    elsif user.donee_of?(wish)
      base_path = 'user_my_wish_path'
    elsif user.donor_of?(wish)
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
    if user.donor_of?(wish)
      class_for_state(wish, user)
    else
      ''
    end
  end

  def donor_infos_for(wish, user = current_user)
    return unless wish.call_for_co_donors? && user.donor_of?(wish)

    tag.span(I18n.t('wishes.actions.call_for_co_donors.notice', user_name: wish.called_for_co_donors_by_user.name),
             class: 'donor_infos rz-wish__notice')
  end

  def icon_of_wish_sharing(wish)
    kind = wish.shared? ? :shared : :personal
    tooltip = I18n.t("wishes.shared_icon_tooltip.#{kind}")
    tag.span(render(IconComponent.new(wish.shared? ? 'group' : 'person')),
             class: 'shared-wish-icon', id: "#{anchor_for(wish)}_shared_icon", title: tooltip,
             role: 'img', aria: { label: tooltip })
  end
end
