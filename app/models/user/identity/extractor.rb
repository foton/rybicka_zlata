#Interface class for providing data from auth hashes
#for every provider implement subclass !
class User::Identity::Extractor
  
  def initialize(auth_data={})
    @auth_data=auth_data
  end  

  def auth_data=(a)
    @auth_data=a
  end  
  
  def name
    nil
  end

  def locale
    nil
  end  

  def verified_email
    nil
  end  
end
