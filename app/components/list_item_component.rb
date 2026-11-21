# frozen_string_literal: true

# Row of ListComponent: primary content (block) + the object's available actions,
# as buttons on wide screens and as an overflow menu on phones.
# Id and classes come from ActionsHelper (anchor_for / classes_for), so Turbo Streams
# can replace every row of the same object (a wish may be listed under several donees).
class ListItemComponent < ApplicationComponent
  def initialize(object:, user:, remote: false)
    super()
    @object = object
    @user = user
    @remote = remote
  end

  def actions
    @actions ||= @object.available_actions_for(@user) - [:show]
  end

  private

  attr_reader :object, :user, :remote

  def action_component(action, menu_item: false)
    ObjectActionComponent.new(action: action, user: user, object: object, remote: remote,
                              params: { state_action: action }, menu_item: menu_item)
  end
end
