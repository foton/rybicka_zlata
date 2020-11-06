# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
#  content         :text
#  show_to_anybody :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  author_id       :bigint
#  wish_id         :bigint
#
module Discussion
  class Post < ApplicationRecord
    belongs_to :wish
    belongs_to :author, class_name: 'User'

    def anchor
      "post_#{id}"
    end
  end
end
