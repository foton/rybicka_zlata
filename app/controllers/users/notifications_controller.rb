# frozen_string_literal: true

module Users
  # In-app notifications of the signed in user (replaces activity_notification's controller).
  class NotificationsController < ApplicationController
    OPENED_LIMIT = 10 # read notifications shown under the unread ones

    before_action :set_user
    before_action :load_notification, only: %i[show open move]

    def index
      scope = @user.notifications.includes(:notifier, :notifiable).latest_first
      @notifications = scope.unopened_only.to_a + scope.opened_only.limit(OPENED_LIMIT).to_a
    end

    def show; end

    # marks the notification read; with move=true continues to the wish
    def open
      @notification.open!
      if params[:move].present?
        redirect_to notification_target_path(@notification)
      else
        redirect_back_or_to user_notifications_path(@user)
      end
    end

    def open_all
      @user.notifications.open_all!
      redirect_to user_notifications_path(@user)
    end

    def move
      @notification.open! if params[:open].present?
      redirect_to notification_target_path(@notification)
    end

    private

    def load_notification
      @notification = @user.notifications.find(params.expect(:id))
    end

    # Wish or post: /wishes/:id (Wishes::BaseController sends the user to the right view of it)
    def notification_target_path(notification)
      wish = notification.wish
      return user_notifications_path(@user) if wish.blank?

      anchor = notification.notifiable.anchor if notification.notifiable.is_a?(Discussion::Post)
      wish_path(wish, anchor: anchor)
    end
  end
end
