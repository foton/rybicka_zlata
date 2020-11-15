# frozen_string_literal: true


class WishCreator
  attr_accessor :errors, :result
  attr_accessor :author, :wish_params

  def self.call(wish_params, author)
    srv = new(wish_params, author)
    srv.call
    srv
  end

  def initialize(wish_params, author)
    @wish_params = wish_params
    @author = author
  end

  def call
    @errors = []
    @result = create_wish
  end

  def success?
    errors.blank?
  end

  def failed?
    !success?
  end

  private

  attr_reader :wish

  def create_wish
    modified_params= wish_params.dup
    modified_params.delete(:user_id) # should be same as author_id
    donor_conn_ids = modified_params.delete(:donor_conn_ids)

    @wish = Wish::FromAuthor.new
    @wish.author = author
    @wish.updated_by = author
    @wish.attributes = modified_params # author must be set at this moment
    @wish.merge_donor_conn_ids(donor_conn_ids, author)

    if @wish.save
      notify_users
    else
      errors << "Error on creating wish, see wish.errors"
    end
    @wish
  end

  def notify_users
    wish.notify(:donors, key: 'wish.notifications.created.you_as_donor', notifier: author)
    wish.notify(:donees, key: 'wish.notifications.created.you_as_donee', notifier: author)
  end
end
