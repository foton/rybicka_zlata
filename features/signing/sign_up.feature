# encoding: utf-8
# language: en
Feature:  Signing Up / Registartions
  As non registered user,
  I want to get acces and account in this app
  to write down and fullfill wishes

  Scenario: Signing Up directly to app (devise)
    Given I am on home page
    And I click on "Sign Up"
    And fill in "email" with "test@rybickazlata.cz"
    And fill in "password" with "PassW0rd"
    And fill in "password confirmation" with "PassW0rd"
    And click on "Register"

    Then I should receive email with confirmation link

