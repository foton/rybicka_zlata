# == Schema Information
#
# Table name: posts
#
#  author_id       :integer
#  content         :text
#  created_at      :datetime         not null
#  id              :integer          not null, primary key
#  show_to_anybody :boolean          default(FALSE)
#  updated_at      :datetime         not null
#  wish_id         :integer
#

module Discussion
  class Post < ApplicationRecord
    include WishesHelper

    belongs_to :wish
    belongs_to :author, class_name: 'User'

    include Notifiable
    # on deletion (post no longer persisted) everybody is informed, the author too
    notifies :donors, targets: ->(post, _key) { post.wish.donor_users - (post.persisted? ? [post.author] : []) }
    notifies :donees, targets: ->(post, _key) { post.wish.donee_users - (post.persisted? ? [post.author] : []) }

    def anchor
      "post_#{id}"
    end

    def wish_title
      wish.wish_title
    end
  end
end
