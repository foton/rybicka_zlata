# frozen_string_literal: true

require 'test_helper'

# Ported from ActionsHelperTest (tag_to_object_action): URL per role, HTTP method,
# state_action param, extra params, delete confirmation, remote (Turbo) forms.
class ObjectActionComponentTest < ViewComponent::TestCase
  include Rails.application.routes.url_helpers
  include WishesHelper

  def setup
    prepare_wish_and_others
  end

  def test_actions_for_author
    assert_get_link(:show, @author)
    assert_get_link(:edit, @author)
    assert_delete_form(@author)
    assert_state_form(:fulfilled, @author)
  end

  def test_actions_for_donee
    assert_get_link(:show, @donee)
    assert_get_link(:edit, @donee)
    assert_delete_form(@donee)
    assert_state_form(:fulfilled, @donee)
  end

  def test_actions_for_donor
    %i[book call_for_co_donors].each { |action| assert_state_form(action, @donor) }

    @wish.book!(@donor)
    %i[unbook gifted].each { |action| assert_state_form(action, @donor) }

    @wish.unbook!(@donor)
    @wish.call_for_co_donors!(@donor)
    assert_state_form(:withdraw_call, @donor)
  end

  def test_state_action_param_is_only_added_to_state_actions
    render_action(:edit, @donee, params: { state_action: :edit })
    assert_nil query_of(page.find('a.edit')[:href])['state_action']

    render_action(:delete, @donee, params: { state_action: :delete })
    assert_nil query_of(page.find('form')[:action])['state_action']
  end

  def test_additional_params_are_kept
    render_action(:edit, @author, params: { bb: 11 })
    assert_equal '11', query_of(page.find('a.edit')[:href])['bb']

    render_action(:fulfilled, @author, params: { state_action: :fulfilled, bb: 11 })
    query = query_of(page.find('form')[:action])
    assert_equal '11', query['bb']
    assert_equal 'fulfilled', query['state_action']
  end

  def test_remote_actions_are_turbo_forms_and_links_stay_links
    render_action(:delete, @author, remote: true)
    form = page.find('form')
    assert_equal 'true', form['data-turbo']
    assert_equal confirm_message, form['data-turbo-confirm']
    assert_nil form['data-rz-confirm']

    render_action(:edit, @author, remote: true)
    assert_selector 'a.edit'
    assert_no_selector '[data-turbo]'
  end

  def test_menu_item_variant
    render_action(:book, @donor, menu_item: true)

    assert_selector 'form.rz-menu__form button.rz-menu__item.book'
    assert_no_selector '[id]'
  end

  private

  def render_action(action, user, params: {}, **)
    with_request_url('/') do
      render_inline(ObjectActionComponent.new(action: action, user: user, object: @wish,
                                              params: params, **))
    end
  end

  def assert_get_link(action, user)
    render_action(action, user)
    link = page.find("a.#{action}##{"wishes_#{action}_#{@wish.id}"}",
                     text: I18n.t("wishes.actions.#{action}.button"))
    assert_equal path_to_wish_action_for_user(action, user, @wish), URI(link[:href]).path
    assert_no_selector 'form'
  end

  def assert_delete_form(user) # rubocop:disable Metrics/AbcSize
    render_action(:delete, user)
    form = page.find('form')
    assert_equal path_to_wish_action_for_user(:delete, user, @wish), URI(form[:action]).path
    assert_selector 'input[name="_method"][value="delete"]', visible: :all
    assert_equal confirm_message, form['data-rz-confirm']
    assert_equal 'Ano', form['data-confirm-yes']
    assert_equal 'Ne', form['data-confirm-no']
    assert_nil form['data-turbo']
    assert_selector 'button.delete', text: 'Smazat'
  end

  def assert_state_form(action, user) # rubocop:disable Metrics/AbcSize
    render_action(action, user, params: { state_action: action })
    form = page.find('form')
    assert_equal path_to_wish_action_for_user(action, user, @wish), URI(form[:action]).path
    assert_equal action.to_s, query_of(form[:action])['state_action']
    assert_selector 'input[name="_method"][value="patch"]', visible: :all
    assert_selector "button.#{action}##{"wishes_#{action}_#{@wish.id}"}",
                    text: I18n.t("wishes.actions.#{action}.button")
  end

  def confirm_message
    "Opravdu chcete přání '#{@wish.title}' smazat?"
  end

  def query_of(url)
    Rack::Utils.parse_query(URI(url).query)
  end
end
