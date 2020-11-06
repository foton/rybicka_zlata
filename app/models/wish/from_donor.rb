# frozen_string_literal: true

# == Schema Information
#
# Table name: wishes
#
#  id                         :integer          not null, primary key
#  description                :text
#  state                      :integer          default(0), not null
#  title                      :string           not null
#  updated_by_donee_at        :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#  author_id                  :integer          not null
#  booked_by_id               :integer
#  called_for_co_donors_by_id :integer
#
# donor can change state of wish only
class Wish::FromDonor < Wish
  self.table_name = 'wishes'

  def destroy(_by_user = nil)
    # no destroy for Donor
    false
  end

  # return array of strings (names) of donees, which are known to user
  def donee_names_for(user)
    @donee_names = {} unless defined? @donee_names

    @donee_names[user.id] = collect_donee_names_for(user) if @donee_names[user.id].nil?

    @donee_names[user.id]
  end

  # IF donee_connection links to user (aka friend)?
  #    a) user (donor) have it's own connection to that friend => display connection.name
  #    b) user (donor) do not have such connection => display friend.displayed_name
  # ELSE # donee_connection do not have friend
  #    a) user (donor) have it's own connection with same email as in donee_connection => display connection.name
  #    b) user (donor) do not have such connection => display donee_connection.name


  def collect_donee_names_for(user)
    donee_connections.collect do |conn|
      if conn.friend # donee is user of app
        if (user_conn = user.connections.find_by(friend_id: conn.friend_id))
          user_conn.name
        else
          conn.friend.displayed_name
        end
      elsif (user_conn = user.connections.find_by(email: conn.email))
        user_conn.name
      end
    end.compact.sort
  end
end
