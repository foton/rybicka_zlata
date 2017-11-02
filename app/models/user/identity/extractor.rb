# frozen_string_literal: true

# Interface class for providing data from auth hashes
# for every provider implement subclass !
class User::Identity::Extractor
  def initialize(auth_data = {})
    @auth_data = auth_data
  end

  attr_writer :auth_data

  def name
    nil
  end

  def locale
    nil
  end

  def time_zone
    nil
  end

  def email
    nil
  end

  def verified_email
    nil
  end
end
