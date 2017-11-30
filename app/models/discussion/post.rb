module Discussion
  class Post < ApplicationRecord
    belongs_to :wish
    belongs_to :author, class_name: 'User'

    def anchor
      "post_#{id}"
    end
  end
end
