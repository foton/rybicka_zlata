# frozen_string_literal: true

# managing posts with autorization what can user see
class DiscussionService
  class NotAuthorizedError < StandardError; end

  POST_CLASS = Discussion::Post

  def self.find_post(id)
    POST_CLASS.find(id)
  end

  def initialize(wish, user)
    @wish = wish
    @user = user
  end

  def posts
    @posts ||= if user_is_donor?
                 all_posts
               else
                 just_not_secret_posts
               end
  end

  def build_post
    POST_CLASS.new(wish_id: @wish.id, author_id: @user.id)
  end

  def add_post(attributes)
    raise NotAuthorizedError unless can_add_post?
    POST_CLASS.create!(modify_visibility(attributes).merge(wish_id: @wish.id, author_id: @user.id))
  end

  def delete_post(post)
    raise NotAuthorizedError unless can_delete_post?(post)
    post.destroy
    @posts = nil
    posts.last
  end

  def can_add_post?
    user_is_donor? || !posts.empty?
  end

  def can_delete_post?(post)
    @user.admin? \
    || (@user == post.author \
        && all_posts.last == post \
        && post.created_at > (Time.zone.now - 1.day))
  end

  def forced_visibility_for_posts?
    !user_is_donor?
  end

  def user_role
    user_is_donor? ? 'donor' : 'donee'
  end

  private

  def just_not_secret_posts
    all_posts.where(show_to_anybody: true)
  end

  def all_posts
    POST_CLASS.where(wish_id: @wish.id)
  end

  def user_is_donor?
    @user_is_donor ||= @wish.donor?(@user)
  end

  # if author is donee/author of wish, visibility is set to true
  def modify_visibility(attributes)
    attributes[:show_to_anybody] ||= !user_is_donor?
    attributes
  end
end
