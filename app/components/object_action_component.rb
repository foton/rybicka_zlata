# frozen_string_literal: true

# One action (show, edit, delete, book, fulfilled, ...) on an object (wish, connection,
# group, identity) for a user, rendered as an M3 button or as a menu item.
# Replaces ActionsHelper#tag_to_object_action.
#
#   render ObjectActionComponent.new(action: :book, user: @user, object: wish, remote: true)
#
# GET actions are links; the others are real forms (button_to). remote: true lets Turbo
# submit the form and expects a Turbo Stream response (list rows); otherwise it is a plain
# form with a full page response. CSS class = action name (used by tests and styles).
class ObjectActionComponent < ApplicationComponent
  GET_ACTIONS = %i[new show edit].freeze
  DELETE_ACTIONS = %i[delete destroy].freeze

  def initialize(action:, user:, object:, params: {}, remote: false, # rubocop:disable Metrics/ParameterLists
                 variant: :tonal, menu_item: false)
    super()
    @action = action.to_sym
    @user = user
    @object = object
    @params = params.except(:state_action)
    @remote = remote && !get?
    @variant = menu_item ? :menu_item : variant
    @menu_item = menu_item
  end

  def call
    render ButtonComponent.new(label, href: url, method: http_method, variant: @variant,
                                      confirm: confirm, turbo: @remote,
                                      class: css_class, id: element_id)
  end

  def label
    t("#{i18n_prefix}.actions.#{@action}.button")
  end

  def http_method
    return :get if get?
    return :delete if delete?

    :patch
  end

  def url
    params = @params.dup
    params[:state_action] = route_action if state_action?
    if @object.is_a?(Wish)
      helpers.path_to_wish_action_for_user(route_action, @user, @object, params)
    else
      helpers.url_for(action: (delete? ? :destroy : route_action), controller: controller_path,
                      user_id: @user.id, id: @object&.id, params: params)
    end
  end

  def confirm
    return unless delete?

    { message: t("#{i18n_prefix}.actions.delete.confirm.message", object_title: object_title),
      yes: t('confirm.yes'), no: t('confirm.no') }
  end

  private

  def route_action
    @action == :another_new ? :new : @action
  end

  def get?
    GET_ACTIONS.include?(route_action)
  end

  def delete?
    DELETE_ACTIONS.include?(@action)
  end

  def state_action?
    return false if get? || delete?

    @object.respond_to?(:available_state_actions_for) &&
      @object.available_state_actions_for(@user).include?(@action)
  end

  # menu items get no id: the same action is also rendered as a button in the row
  def element_id
    return if @menu_item

    ["#{i18n_prefix.tr('.', '_')}_#{route_action}", @object&.id].compact.join('_')
  end

  def css_class
    route_action.to_s
  end

  def object_title
    @object.respond_to?(:title) ? @object.title : @object.displayed_name
  end

  def i18n_prefix
    case @object
    when Wish then 'wishes'
    when User::Identity then 'user.identities'
    when Group then 'groups'
    when Connection then 'connections'
    else ''
    end
  end

  def controller_path
    @object.is_a?(User::Identity) ? 'users/identities' : i18n_prefix
  end
end
