# frozen_string_literal: true

module ActionsHelper
  def classes_for(obj, user)
    id_cls = anchor_for(obj)
    if obj.is_a?(Wish::FromDonor)
      id_cls + ' wish ' + donor_class_for_state(obj, user)
    elsif obj.is_a?(Wish)
      if user.donor_of?(obj)
        id_cls + ' wish ' + donor_class_for_state(obj, user)
      else
        id_cls + ' wish'
      end
    elsif obj.is_a?(User::Identity)
      id_cls + ' contact'
    elsif obj.is_a?(Group)
      id_cls + ' group'
    elsif obj.is_a?(Connection)
      id_cls + ' connection'
    else
      id_cls
    end
  end

  def anchor_for(obj)
    (obj.is_a?(Wish) ? 'wish' : obj.class.to_s).downcase.dasherize + '_' + obj.id.to_s
  end
end
