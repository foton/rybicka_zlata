# frozen_string_literal: true

require 'test_helper'

class FixtureConsistencyTest < ActiveSupport::TestCase
  def setup
    @bart = users(:bart)
    @lisa = users(:lisa)
    @marge = users(:marge)
    @homer = users(:homer)
    @maggie = users(:maggie)

    @wishes = {
      'Bart wish (shown only to Homer)' => { donors: { @bart => [@homer] },
                                             donees: [@bart] },
      'B: New faster skateboard' => { donors: { @bart => [@homer, @marge, @lisa] },
                                      donees: [@bart] },
      'M: Taller hairs' => { donors: { @marge => [@lisa, @homer, @bart] },
                             donees: [@marge] },
      'M+H: Your parents on holiday' => { donors: { @marge => [@lisa], @homer => [@bart] },
                                          donees: [@marge, @homer] },
      'L+B: Bigger family car' => { donors: { @bart => [@homer], @lisa => [@homer, @marge] },
                                    donees: [@bart, @lisa] },
      'Lisa wish (shown only to Bart)' => { donors: { @lisa => [@bart] },
                                            donees: [@lisa] },
      'Lisa wish (shown only to Marge)' => { donors: { @lisa => [@marge] },
                                            donees: [@lisa] }
    }

    @connections = {
      @bart => { 'Liiiisaaa' => @lisa, 'Dad' => @homer, 'Mom' => @marge, 'Meg' => @maggie, 'Milhouse' => nil },
      @lisa => { 'Misfit' => @bart, 'Dad' => @homer, 'Mom' => @marge, 'Rachel C' => nil },
      @marge => { 'Son' => @bart, 'Daughter' => @lisa, 'Husband' => @homer, 'Little one' => @maggie },
      @homer => { 'MiniMe' => @bart },
      @maggie => { 'Mom' => @marge }
    }
  end

  test 'required users exists' do
    assert @bart.present?
    assert @lisa.present?
    assert @marge.present?
    assert @homer.present?
    assert @maggie.present?
  end

  test 'Users have identities' do
    identities = {
      @bart => [:local, 'bartman@simpsons.com'],
      @lisa => [:local],
      @marge => [:local],
      @homer => [:local],
      @maggie => [:local]
    }

    identities.each_pair do |user, expected_identities|
      assert_equal expected_identities.size, user.identities.size

      expected_identities.each do |expected_identity|
        if expected_identity == :local
          expected_provider = User::Identity::LOCAL_PROVIDER
          expected_email = user.email
        else
          expected_provider = 'test'
          expected_email = expected_identity
        end

        identity = user.identities.detect { |idn| idn.email == expected_email }
        assert identity.present?, "Identity with email '#{expected_email}' was not found between identities #{user.identities.to_json}"
        assert_equal expected_provider, identity.provider, "For identity '#{identity.to_json}', '#{expected_provider}' provider was expected"
      end
    end
  end

  test 'Bart have second identity' do
    assert_equal 2, @bart.identities.size

    first_idnt = @bart.identities.find_by(email: @bart.email)
    second_idnt = @bart.identities.find_by(email: 'bartman@simpsons.com')
    assert_equal [@marge.id, @homer.id, @bart.id].sort, first_idnt.connections.pluck(:owner_id).sort
    assert_equal [@lisa.id], second_idnt.connections.pluck(:owner_id).sort
  end

  test 'Connections are present' do
    @connections.each_pair do |user, conns_hash|
      all_cons = conns_hash.dup
      all_cons[Connection::BASE_CONNECTION_NAME] = user

      assert_equal all_cons.keys.size, user.connections.size

      all_cons.each_pair do |conn_name, friend|
        conn = user.connections.detect { |con| con.name == conn_name }
        assert conn.present?, "Connection with name #{conn_name} was not found between #{user.name} connections"
        next unless friend

        assert_equal friend, conn.friend , "Connection '#{user.name}::#{conn_name}' have different friend: expected #{friend}, got #{conn.friend}"
      end
    end
  end

  test 'Bart have group' do
    group = @bart.groups.find_by(name: 'Family (without Maggie)')
    assert group.present?
    assert_equal [@marge.id, @homer.id, @lisa.id].sort, group.connections.pluck(:friend_id).sort
  end

  test 'Wishes are binded to other users' do
    assert_equal @wishes.size, Wish.count

    @wishes.each_pair do |wish_title, users_hash|
      wish = Wish.find_by(title: wish_title)
      assert wish.present?, "Wish with name #{wish_title} was not found between wishes"

      all_donors = users_hash[:donors].values.flatten
      assert_not all_donors.size.zero?
      assert_equal all_donors.size, wish.donor_links.size, "Wish '#{wish_title}' should have #{users_hash[:donors].size} donor links"
      users_hash[:donors].each_pair do |donee_user, donor_users|
        donor_users.each do |donor_user|
          assert wish.donor?(donor_user), "Wish '#{wish_title}' should have `#{donor_user.name}` between donors"
          correct_connection = donee_user.connections.detect { |con| con.friend == donor_user }
          correct_link = wish.donor_links.detect { |link| link.connection == correct_connection }
          assert correct_link.present?,
                 "There should be donor link to connection between donee: #{donee_user.name}[#{donee_user.id}] and donor: #{donor_user.name}[#{donor_user.id}] for wish #{wish.title}, but we have #{wish.donor_links.collect {|link| link.connection.to_json }}"
        end
      end

      assert_not users_hash[:donees].size.zero?
      assert_equal users_hash[:donees].size, wish.donee_links.size, "Wish '#{wish_title}' should have #{users_hash[:donees].size} donee links"
      users_hash[:donees].each do |donee_user|
        assert wish.donee?(donee_user), "Wish '#{wish_title}' should have `#{donee_user.name}` between donees"
      end
      assert wish.author?(users_hash[:donees].first), "Wish '#{wish_title}' should have `#{users_hash[:donees].first.name}` as author"
    end
  end
end
