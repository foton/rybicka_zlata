# frozen_string_literal: true

# RUN SINGLE TEST?
# rake test TEST=test/models/identity_test.rb TESTOPTS="--name=test_can_be_created_from_auth_without_user -v"

# RUN ALL TESTS IN FILE?
# rake test TEST=test/models/identity_test.rb

require 'simplecov' # using global config file .simplecov

require 'minitest/reporters'
require 'rake_rerun_reporter'

reporter_options = { color: true, slow_count: 5, verbose: false, rerun_prefix: 'rm -f log/*.log && be' }
# Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]
Minitest::Reporters.use! [Minitest::Reporters::RakeRerunReporter.new(reporter_options)]

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# fast truncation of all tables that need truncations (select is 10x faster then truncate)
# http://grosser.it/2012/07/03/rubyactiverecord-fastest-way-to-truncate-test-database/
def truncate_all_tables
  config = ActiveRecord::Base.configurations[::Rails.env]
  connection = ActiveRecord::Base.connection
  connection.disable_referential_integrity do
    connection.tables.each do |table_name|
      next if  table_name == 'schema_migrations'
      next if connection.select_value("SELECT count(*) FROM #{table_name}") == 0
      case config['adapter']
      when 'mysql', 'mysql2', 'postgresql'
        connection.execute("TRUNCATE #{table_name} CASCADE")
      when 'sqlite', 'sqlite3'
        connection.execute("DELETE FROM #{table_name}")
        connection.execute("DELETE FROM sqlite_sequence where name='#{table_name}'")
      end
    end
    connection.execute('VACUUM') if config['adapter'] == 'sqlite3'
  end
end

class ActiveSupport::TestCase
  truncate_all_tables

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_test_user!(attrs = {})
    default_email = 'john.doe@test.com'
    if attrs[:email].blank?
      attrs[:email] = if attrs[:name].present?
                        default_email.gsub('john.doe', attrs[:name].parameterize)
                      else
                        default_email
                      end
    end

    usrs = User.where(email: attrs[:email])
    if usrs.blank?
      user = User.new({ name: 'John Doe', email: default_email, password: 'my_Password10' }.merge(attrs))
      user.skip_confirmation!
      raise "User not created! #{user.errors.full_messages.join(';')}" unless user.save
      user
    else
      usrs.first
    end
 end

  def create_connection_for(user, conn_hash)
    conn_name = conn_hash[:name]
    conn_email = conn_hash[:email]

    conns = user.connections.where(name: conn_name)
    if conn_email.present? && conns.present?
      conns = conns.select { |conn| conn.email == conn_email }
    end

    if conns.blank?
      # lets create it
      conn_email = "#{conn_name}@example.com" if conn_email.blank?
      conn = Connection.new(name: conn_name, email: conn_email, owner_id: user.id)
      raise "Connection not created! #{conn.errors.full_messages.join(';')}" unless conn.save
      user.connections.reload
    elsif conns.size != 1
      raise "Ambiguous match for '#{conn_hash[:connection]}' for user '#{user.username}': #{conns.join("\n")}"
    else
      conn = conns.first
    end
    conn
  end

  def setup_wish
    @author = create_test_user!(name: 'author')
    @donor = create_test_user!(name: 'donor')
    @donee = create_test_user!(name: 'donee')

    assert @author != @donor
    assert @author != @donee
    assert @donee != @donor

    @donor_conn = create_connection_for(@author, name: 'donor_conn', email: @donor.email)
    @donee_conn = create_connection_for(@author, name: 'donee_conn', email: @donee.email)

    @wish = Wish::FromAuthor.new(
      author: @author,
      title: 'My first wish',
      description: 'This is my first wish I am trying',
      donee_conn_ids: [@donee_conn.id]
    )
    @wish.merge_donor_conn_ids([@donor_conn.id], @author)
    @wish.save!
  end

  def setup_donor2
    @donor2 = create_test_user!(name: 'donor2')
    @donor2_conn = create_connection_for(@author, name: 'donor2_conn', email: @donor2.email)

    @wish.merge_donor_conn_ids([@donor_conn.id, @donor2_conn.id], @author)
    @wish.save!
  end
end
