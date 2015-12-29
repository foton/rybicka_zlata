require 'test_helper'

class DeviseEmailTest < ActionMailer::TestCase

  def setup
    Devise.mailer = 'Devise::Mailer'
    Devise.mailer_sender = 'test@example.com'
    @devise_mailer=Devise::Mailer
    @user_en=User.new(email: "test_en@rybickazlata.cz", locale: :en )
    @user_cs=User.new(email: "test_cs@rybickazlata.cz", locale: :cs )
  end

  def teardown
    I18n.locale = I18n.default_locale
  end  

  # test "confirmation_instruction should be translated" do 
  
  def test_confirmation_instruction_should_be_translated 
   I18n.locale = :cs
   mail=@devise_mailer.confirmation_instructions(@user_cs, "xxx")
   assert mail.body.include?("Vítejte #{@user_cs.email}") , "Body of email is not fully translated:\n #{mail.body}"
   assert mail.body.include?("Svůj účet pro tento e-mail můžete potvrdit kliknutím na odkaz níže:"), "Body of email is not fully translated:\n #{mail.body}"
   assert mail.body.include?("Potvrdit můj ůčet"), "Body of email is not fully translated:\n #{mail.body}"

   I18n.locale = :en
   mail=@devise_mailer.confirmation_instructions(@user_en, "xxx")
   expected=["Welcome #{@user_en.email}" ,
             "You can confirm your account email through the link below:",
             "Confirm my account"]
   for exp_string in expected do
    assert mail.body.include?(exp_string), "Body of email is not fully translated ['#{exp_string}' not found]:\n #{mail.body}"
   end          
  end

end  
