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

    acts_as_notifiable :donors, {
      targets: ->(post, _key) { post.wish.donor_users - (post.persisted? ? [post.author] : []) }  # on deletion we inform everybody
      # notifiable_path: :post_notifiable_path
    }

    acts_as_notifiable :donees, {
      targets: ->(post, _key) { post.wish.donee_users - (post.persisted? ? [post.author] : []) }
      # notifiable_path: :post_notifiable_path
    }

    def anchor
      "post_#{id}"
    end


    # def post_notifiable_path
    #   binding.pry
    #   wish.notifable_path + "#" + anchor
    # end

    def discussion_post_path(_param) # hacking polymorphic_path
      "/wishes/#{wish.id}"
    end

    def wish_title
      wish.wish_title
    end
  end
end
