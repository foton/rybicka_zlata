# frozen_string_literal: true

require 'test_helper'

class RybickaMailerTest < ActionMailer::TestCase
  Message = Struct.new(:subject, :body, :reply_to)

  def test_send_message_to_admin_with_subject_without_user
    subject = 'Subj'
    body = 'Test body'
    reply_to = 'reply@me.cz'
    message = Message.new(subject, body, reply_to)
    adm = create_test_user!(email: 'porybny@rybickazlata.cz')

    email = RybickaMailer.with(message: message, user: nil).message_to_admin
    assert_equal [adm.email, 'foton@centrum.cz'], email.to
    assert_equal [reply_to], email.reply_to
    assert_equal subject, email.subject
    assert email.body.include?(body), "Not found '#{body}' in email.body: '#{email.body}'"
    assert email.body.include?("Odpověď poslat na '#{reply_to}'"), "Not found 'Odpověď poslat na '#{reply_to}'' in email.body: '#{email.body}'"
  end

  def test_send_message_to_admin_without_subject_with_user
    subject = ''
    body = 'Test body'
    reply_to = nil
    message = Message.new(subject, body, reply_to)
    usr = create_test_user!(name: 'r2d2')
    adm = create_test_user!(email: 'porybny@rybickazlata.cz')

    email = RybickaMailer.with(message: message, user: usr).message_to_admin
    assert_equal [adm.email, 'foton@centrum.cz'], email.to
    assert_equal [usr.email], email.reply_to
    assert_equal "Zpráva pro Porybného od uživatele '#{usr.name}'", email.subject
    assert email.body.include?(body), "Not found '#{body}' in email.body: '#{email.body}'"
    assert email.body.include?("Odpověď poslat na '#{reply_to}'"), "Not found 'Odpověď poslat na '#{reply_to}'' in email.body: '#{email.body}'"
  end
end
