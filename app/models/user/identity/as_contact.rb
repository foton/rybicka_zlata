#User::Idenity used when creatin Contacts for current user (adding more his/her emails)
class User::Identity::AsContact < User::Identity   #< ActiveType::Record[User::Idenity] 
  before_validation :have_local_provider

  private

    def have_local_provider
    	self.provider=User::Identity::LOCAL_PROVIDER
    end
end
