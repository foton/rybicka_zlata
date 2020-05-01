# frozen_string_literal: true

require 'test_helper'
require 'application_helper'
require 'wishes_helper'

class ActionsHelperTest < ActionView::TestCase
  include ApplicationHelper
  include WishesHelper

  def setup
    prepare_wish_and_others
  end

  def test_link_to_wish_for_author
    tab = [[:show, "<span><a id=\"wishes_show_#{@wish.id}\" class=\"show\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:show, @author, @wish)}\">Zobrazit</a></span>"]]
    tab << [:edit, "<span><a id=\"wishes_edit_#{@wish.id}\" class=\"edit\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:edit, @author, @wish)}\">Upravit</a></span>"]
    tab << [:delete, "<span><a id=\"wishes_delete_#{@wish.id}\" class=\"delete\" data-confirm=\"Opravdu chcete přání #{@html_safe_wish_name_with_quotes} smazat?\" data-confirm-yes=\"Ano\" data-confirm-no=\"Ne\" rel=\"nofollow\" data-method=\"delete\" href=\"#{path_to_wish_action_for_user(:delete, @author, @wish)}\">Smazat</a></span>"]
    tab << [:fulfilled, "<span><a id=\"wishes_fulfilled_#{@wish.id}\" class=\"fulfilled\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(:fulfilled, @author, @wish, state_action: :fulfilled)}\">Splněno</a></span>"]

    for t in tab
      action = t.first
      result = tag_to_object_action(:a, action, @author, @wish, false)
      assert_equal t.last, result, "tag_to_object_action(:a,#{action}) is unexpectly: #{result}"
    end
   end

  def test_link_to_wish_for_author_through_remote
    tab = [[:show, "<span><a id=\"wishes_show_#{@wish.id}\" class=\"show\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:show, @author, @wish)}\">Zobrazit</a></span>"]]
    tab << [:edit, "<span><a id=\"wishes_edit_#{@wish.id}\" class=\"edit\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:edit, @author, @wish)}\">Upravit</a></span>"]
    tab << [:delete, "<span><a id=\"wishes_delete_#{@wish.id}\" class=\"delete\" data-confirm=\"Opravdu chcete přání #{@html_safe_wish_name_with_quotes} smazat?\" data-confirm-yes=\"Ano\" data-confirm-no=\"Ne\" data-remote=\"true\" rel=\"nofollow\" data-method=\"delete\" href=\"#{path_to_wish_action_for_user(:delete, @author, @wish)}\">Smazat</a></span>"]
    tab << [:fulfilled, "<span><a id=\"wishes_fulfilled_#{@wish.id}\" class=\"fulfilled\" data-remote=\"true\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(:fulfilled, @author, @wish, state_action: :fulfilled)}\">Splněno</a></span>"]

    for t in tab
      action = t.first
      result = tag_to_object_action(:a, action, @author, @wish, true)
      assert_equal t.last, result, "tag_to_object_action(:a,#{action}) is unexpectly: #{result}"
    end
  end

  def test_link_to_wish_for_author_through_remote_with_additional_params
    tab = [[:show, "<span><a id=\"wishes_show_#{@wish.id}\" class=\"show\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:show, @author, @wish, bb: 11)}\">Zobrazit</a></span>"]]
    tab << [:edit, "<span><a id=\"wishes_edit_#{@wish.id}\" class=\"edit\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:edit, @author, @wish, bb: 11)}\">Upravit</a></span>"]
    tab << [:delete, "<span><a id=\"wishes_delete_#{@wish.id}\" class=\"delete\" data-confirm=\"Opravdu chcete přání #{@html_safe_wish_name_with_quotes} smazat?\" data-confirm-yes=\"Ano\" data-confirm-no=\"Ne\" data-remote=\"true\" rel=\"nofollow\" data-method=\"delete\" href=\"#{path_to_wish_action_for_user(:delete, @author, @wish, bb: 11)}\">Smazat</a></span>"]
    # '&' joinning params is converted to &amp; in link_to helper
    tab << [:fulfilled, "<span><a id=\"wishes_fulfilled_#{@wish.id}\" class=\"fulfilled\" data-remote=\"true\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(:fulfilled, @author, @wish, state_action: :fulfilled, bb: 11).gsub('&', '&amp;')}\">Splněno</a></span>"]

    for t in tab
      action = t.first
      result = tag_to_object_action(:a, action, @author, @wish, true, bb: 11)
      assert_equal t.last, result, "tag_to_object_action(:a,#{action}) is unexpectly: #{result}"
    end
  end

  def test_link_to_wish_for_donee
    tab = [[:show, "<span><a id=\"wishes_show_#{@wish.id}\" class=\"show\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:show, @donee, @wish)}\">Zobrazit</a></span>"]]
    tab << [:edit, "<span><a id=\"wishes_edit_#{@wish.id}\" class=\"edit\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:edit, @donee, @wish)}\">Upravit</a></span>"]
    tab << [:delete, "<span><a id=\"wishes_delete_#{@wish.id}\" class=\"delete\" data-confirm=\"Opravdu chcete přání #{@html_safe_wish_name_with_quotes} smazat?\" data-confirm-yes=\"Ano\" data-confirm-no=\"Ne\" rel=\"nofollow\" data-method=\"delete\" href=\"#{path_to_wish_action_for_user(:delete, @donee, @wish)}\">Smazat</a></span>"]
    tab << [:fulfilled, "<span><a id=\"wishes_fulfilled_#{@wish.id}\" class=\"fulfilled\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(:fulfilled, @donee, @wish, state_action: :fulfilled)}\">Splněno</a></span>"]

    for t in tab
      action = t.first
      result = tag_to_object_action(:a, action, @donee, @wish, false, state_action: action)
      assert_equal t.last, result, "tag_to_object_action(:a,#{action}) is unexpectly: #{result}"
    end
  end

  def test_link_to_wish_for_donor
    for action in %i[book call_for_co_donors]
      expected = "<span><a id=\"wishes_#{action}_#{@wish.id}\" class=\"#{action}\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(action, @donor, @wish, state_action: action)}\">#{I18n.t("wishes.actions.#{action}.button")}</a></span>"
      result = tag_to_object_action(:a, action, @donor, @wish, false)
      assert_equal expected, result, "tag_to_object_action(:a,#{action}) is unexpectly: #{result}"
    end

    @wish.book!(@donor)

    for action in %i[unbook gifted]
      expected = "<span><a id=\"wishes_#{action}_#{@wish.id}\" class=\"#{action}\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(action, @donor, @wish, state_action: action)}\">#{I18n.t("wishes.actions.#{action}.button")}</a></span>"
      result = tag_to_object_action(:a, action, @donor, @wish, false)
      assert_equal expected, result, "tag_to_object_action(:a,#{action}) is unexpectly: #{result}"
    end

    @wish.unbook!(@donor)
    @wish.call_for_co_donors!(@donor)

    action = :withdraw_call
    expected = "<span><a id=\"wishes_#{action}_#{@wish.id}\" class=\"#{action}\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(action, @donor, @wish, state_action: action)}\">#{I18n.t("wishes.actions.#{action}.button")}</a></span>"
    result = tag_to_object_action(:a, action, @donor, @wish, false)
    assert_equal expected, result, "tag_to_object_action(:a,#{action}) is unexpectly: #{result}"
  end

  def mdl_classes
    'mdl-list__item-secondary-action ' + button_mdl_classes
  end

  def test_button_to_wish_for_author
    tab = [[:show, "<span><a class=\"show #{mdl_classes}\" id=\"wishes_show_#{@wish.id}\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:show, @author, @wish)}\">Zobrazit</a></span>"]]
    tab << [:edit, "<span><a class=\"edit #{mdl_classes}\" id=\"wishes_edit_#{@wish.id}\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:edit, @author, @wish)}\">Upravit</a></span>"]
    tab << [:delete, "<span><a class=\"delete #{mdl_classes}\" id=\"wishes_delete_#{@wish.id}\" data-confirm=\"Opravdu chcete přání #{@html_safe_wish_name_with_quotes} smazat?\" data-confirm-yes=\"Ano\" data-confirm-no=\"Ne\" rel=\"nofollow\" data-method=\"delete\" href=\"#{path_to_wish_action_for_user(:delete, @author, @wish)}\">Smazat</a></span>"]
    tab << [:fulfilled, "<span><a class=\"fulfilled #{mdl_classes}\" id=\"wishes_fulfilled_#{@wish.id}\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(:fulfilled, @author, @wish, state_action: :fulfilled)}\">Splněno</a></span>"]

    for t in tab
      action = t.first
      result = tag_to_object_action(:button, action, @author, @wish, false)
      assert_equal t.last, result, "tag_to_object_action(:button, #{action}) is unexpectly: #{result}"
    end
  end

  def test_button_to_wish_for_author_through_remote
    tab = [[:show, "<span><a class=\"show #{mdl_classes}\" id=\"wishes_show_#{@wish.id}\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:show, @author, @wish)}\">Zobrazit</a></span>"]]
    tab << [:edit, "<span><a class=\"edit #{mdl_classes}\" id=\"wishes_edit_#{@wish.id}\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:edit, @author, @wish)}\">Upravit</a></span>"]
    tab << [:delete, "<span><a class=\"delete #{mdl_classes}\" id=\"wishes_delete_#{@wish.id}\" data-confirm=\"Opravdu chcete přání #{@html_safe_wish_name_with_quotes} smazat?\" data-confirm-yes=\"Ano\" data-confirm-no=\"Ne\" data-remote=\"true\" rel=\"nofollow\" data-method=\"delete\" href=\"#{path_to_wish_action_for_user(:delete, @author, @wish)}\">Smazat</a></span>"]
    tab << [:fulfilled, "<span><a class=\"fulfilled #{mdl_classes}\" id=\"wishes_fulfilled_#{@wish.id}\" data-remote=\"true\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(:fulfilled, @author, @wish, state_action: :fulfilled)}\">Splněno</a></span>"]

    for t in tab
      action = t.first
      result = tag_to_object_action(:button, action, @author, @wish, true)
      assert_equal t.last, result, "tag_to_object_action(:button, #{action}) is unexpectly: #{result}"
    end
  end

  def test_button_to_wish_for_author_through_remote_with_additional_params
    tab = [[:show, "<span><a class=\"show #{mdl_classes}\" id=\"wishes_show_#{@wish.id}\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:show, @author, @wish, bb: 11)}\">Zobrazit</a></span>"]]
    tab << [:edit, "<span><a class=\"edit #{mdl_classes}\" id=\"wishes_edit_#{@wish.id}\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:edit, @author, @wish, bb: 11)}\">Upravit</a></span>"]
    tab << [:delete, "<span><a class=\"delete #{mdl_classes}\" id=\"wishes_delete_#{@wish.id}\" data-confirm=\"Opravdu chcete přání #{@html_safe_wish_name_with_quotes} smazat?\" data-confirm-yes=\"Ano\" data-confirm-no=\"Ne\" data-remote=\"true\" rel=\"nofollow\" data-method=\"delete\" href=\"#{path_to_wish_action_for_user(:delete, @author, @wish, bb: 11)}\">Smazat</a></span>"]
    # '&' joinning params is converted to &amp; in link_to helper
    tab << [:fulfilled, "<span><a class=\"fulfilled #{mdl_classes}\" id=\"wishes_fulfilled_#{@wish.id}\" data-remote=\"true\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(:fulfilled, @author, @wish, state_action: :fulfilled, bb: 11).gsub('&', '&amp;')}\">Splněno</a></span>"]

    for t in tab
      action = t.first
      result = tag_to_object_action(:button, action, @author, @wish, true, bb: 11)
      assert_equal t.last, result, "tag_to_object_action(:button, #{action}) is unexpectly: #{result}"
    end
  end

  def test_button_to_wish_for_donee
    tab = [[:show, "<span><a class=\"show #{mdl_classes}\" id=\"wishes_show_#{@wish.id}\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:show, @donee, @wish)}\">Zobrazit</a></span>"]]
    tab << [:edit, "<span><a class=\"edit #{mdl_classes}\" id=\"wishes_edit_#{@wish.id}\" data-method=\"get\" href=\"#{path_to_wish_action_for_user(:edit, @donee, @wish)}\">Upravit</a></span>"]
    tab << [:delete, "<span><a class=\"delete #{mdl_classes}\" id=\"wishes_delete_#{@wish.id}\" data-confirm=\"Opravdu chcete přání #{@html_safe_wish_name_with_quotes} smazat?\" data-confirm-yes=\"Ano\" data-confirm-no=\"Ne\" rel=\"nofollow\" data-method=\"delete\" href=\"#{path_to_wish_action_for_user(:delete, @donee, @wish)}\">Smazat</a></span>"]
    tab << [:fulfilled, "<span><a class=\"fulfilled #{mdl_classes}\" id=\"wishes_fulfilled_#{@wish.id}\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(:fulfilled, @donee, @wish, state_action: :fulfilled)}\">Splněno</a></span>"]

    for t in tab
      action = t.first
      result = tag_to_object_action(:button, action, @donee, @wish, false)
      assert_equal t.last, result, "tag_to_object_action(:button, #{action}) is unexpectly: #{result}"
   end
  end

  def test_button_to_wish_for_donor
    for action in %i[book call_for_co_donors]
      expected = "<span><a class=\"#{action} #{mdl_classes}\" id=\"wishes_#{action}_#{@wish.id}\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(action, @donor, @wish, state_action: action)}\">#{I18n.t("wishes.actions.#{action}.button")}</a></span>"
      result = tag_to_object_action(:button, action, @donor, @wish, false)
      assert_equal expected, result, "tag_to_object_action(:button, #{action}) is unexpectly: #{result}"
    end

    @wish.book!(@donor)

    for action in %i[unbook gifted]
      expected = "<span><a class=\"#{action} #{mdl_classes}\" id=\"wishes_#{action}_#{@wish.id}\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(action, @donor, @wish, state_action: action)}\">#{I18n.t("wishes.actions.#{action}.button")}</a></span>"
      result = tag_to_object_action(:button, action, @donor, @wish, false)
      assert_equal expected, result, "tag_to_object_action(:button, #{action}) is unexpectly: #{result}"
    end

    @wish.unbook!(@donor)
    @wish.call_for_co_donors!(@donor)

    action = :withdraw_call
    expected = "<span><a class=\"#{action} #{mdl_classes}\" id=\"wishes_#{action}_#{@wish.id}\" rel=\"nofollow\" data-method=\"patch\" href=\"#{path_to_wish_action_for_user(action, @donor, @wish, state_action: action)}\">#{I18n.t("wishes.actions.#{action}.button")}</a></span>"
    result = tag_to_object_action(:button, action, @donor, @wish, false)
    assert_equal expected, result, "tag_to_object_action(:button, #{action}) is unexpectly: #{result}"
  end
end
