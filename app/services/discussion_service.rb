# frozen_string_literal: true

# managing posts with autorization what can user see
class DiscussionService
  class NotAuthorizedError < StandardError; end

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

  def add_post(attributes)
    raise NotAuthorizedError unless user_can_add?
    post_class.create!(modify_visibility(attributes).merge(wish_id: @wish.id, author_id: @user.id))
  end

  def update_post(attributes, post)
    raise NotAuthorizedError unless user_can_update?(post)
    post.update!(modify_visibility(attributes))
  end

  def delete_post(post)
    raise NotAuthorizedError unless user_can_destroy?(post)
    post.destroy
  end

  def user_can_add?
    user_is_donor? || !posts.empty?
  end

  def user_can_update?(post)
    @user == post.author || @user.admin?
  end

  def user_can_destroy?(post)
    @user == post.author || @user.admin?
  end

  private

  def just_not_secret_posts
    all_posts.where(show_to_anybody: true)
  end

  def all_posts
    post_class.where(wish_id: @wish.id)
  end

  def user_is_donor?
    @user_is_donor ||= @wish.is_donor?(@user)
  end

  def post_class
    Discussion::Post
  end

  # if author is donee/author of wish, visibility is set to true
  def modify_visibility(attributes)
    attributes[:show_to_anybody] ||= !user_is_donor?
    attributes
  end
end
