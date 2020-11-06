# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id       :integer          not null, primary key
#  email    :string
#  provider :string           default(""), not null
#  uid      :string           default(""), not null
#  user_id  :integer
#
# User::Idenity used when creatin Contacts for current user (adding more his/her emails)
class User::Identity::AsContact < User::Identity # < ActiveType::Record[User::Idenity]
  before_validation :have_local_provider

  private

  def have_local_provider
    self.provider = User::Identity::LOCAL_PROVIDER
  end
end
