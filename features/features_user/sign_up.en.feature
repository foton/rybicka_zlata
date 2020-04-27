# encoding: utf-8
# language: en

Feature:  Registrace do aplikace EN
  As nonregistered and no signed in user
  I want to sign up
  ao I can sign in and use Rybicka
Background:
  Given I am on home page
  And I switch locale to "en"

Scenario: Registration of user throught app
  When I click on "Sign up" in menu
  And fill in text "prvni@rybickazlata.cz" into "Primary e-mail" input
  And fill in text "NeznáméHeslo328" into "Password" input
  And fill in text "NeznáméHeslo328" into "Password confirmation" input
  And select "English" from "Language" selection
  And select "(GMT+01:00) Prague" from "Time zone" selection
  And click on button "Sign up"

  Then I should see "A message with a confirmation link has been sent to your email address."
  And I should see " Please follow the link to activate your account."

  When I open last email for "prvni@rybickazlata.cz"
  And click on link "Confirm my account" in email

  Then I should see "Váš účet byl úspěšně potvrzen."

  Then I am able to sign in without trouble with email "prvni@rybickazlata.cz" and password "NeznáméHeslo328"
