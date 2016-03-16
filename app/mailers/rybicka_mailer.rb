class RybickaMailer < ActionMailer::Base
  default from: "porybny@rybickazlata.cz"
  layout 'mailer'

  def message_to_admin(message, user)
    I18n.with_locale(User.admin.locale) do
      @message = message
      @user = user
      subj= @message.subject.present? ? @message.subject : I18n.t("rybickazlata.static.contact_us.message.to_admin.subject", user_name: (@user.nil? ? "" : @user.name) )
      reply_to= @message.reply_to.present? ? @message.reply_to : (user.present? ? user.email : nil)
      
      mail(to: ['porybny@rybickazlata.cz','foton@centrum.cz'], subject: subj, reply_to: reply_to)
    end  
  end  
end
