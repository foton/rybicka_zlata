# frozen_string_literal: true

class RybickaMailer < ActionMailer::Base
  default from: 'porybny@rybickazlata.cz'
  layout 'mailer'

  def message_to_admin
    I18n.with_locale(User.admin.locale) do
      @message = params[:message]
      @user = params[:user]
      subj = @message.subject.presence || I18n.t('rybickazlata.static.contact_us.message.to_admin.subject', user_name: (@user.nil? ? '' : @user.name))
      reply_to = if @message.reply_to.present?
                   @message.reply_to
                 else
                   (@user.present? ? @user.email : nil)
                 end

      mail(to: ['porybny@rybickazlata.cz', 'foton@centrum.cz'], subject: subj, reply_to: reply_to)
    end
  end
end
