# frozen_string_literal: true

# language: cs

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name, _desired_resource = nil)
    page_name = page_name.gsub('stránce ', '').gsub('stránku ', '')
    m = page_name.match(/\A"([^"]*)"\z/)
    page_name = m[1] if m

    case page_name
    when 'úvodní stránce', 'home page'
      root_path(locale: @locale)
    when 'přihlašovací stránce', 'přihlášení', 'signin page', 'login page', 'sign_in'
      new_user_session_path(locale: @locale)
    when 'Profil', 'mé profilové stránce', 'své stránce nastavení', 'své stránce', 'my profile'
      my_profile_path(locale: @locale)
    when 'Kontakty'
      user_connections_path(@current_user, locale: @locale)
    when 'Skupiny'
      user_groups_path(@current_user, locale: @locale)
    when 'Má přání'
      user_my_wishes_path(@current_user, locale: @locale)
    when 'Vyřazená přání'
      user_my_wishes_path(@current_user, locale: @locale, fulfilled: 1)
    when 'Můžu splnit'
      user_others_wishes_path(@current_user, locale: @locale)
    when 'Notifikace'
      user_notifications_path(@current_user)

    else
      if (m = page_name.match(/stránce editace (.*)/) || (m = page_name.match(/editace (.*)/)) || m = page_name.match(/editaci (.*)/))
        if m1 = m[1].match(/kontaktu "([^"]*)"/)
          name = m1[1].to_s
          conn = Connection.find_by(name: name)
          raise "Connection with name '#{name}'' not found!" if conn.blank?

          edit_user_connection_path(@current_user, conn, locale: @locale)
        elsif m1 = m[1].match(/skupiny "([^"]*)"/)
          name = m1[1].to_s
          grp = Group.find_by(name: name)
          raise "Group with name '#{name}'' not found!" if grp.blank?

          edit_user_group_path(@current_user, grp, locale: @locale)

        elsif m = page_name.match(/přání "(.*)"\z/)
          wishes = (@current_user.donee_wishes.where(title: m[1]).to_a + @current_user.donor_wishes.where(title: m[1]).to_a)
          if wishes.blank?
            raise "wish '#{m[1]}' was not found between wishes of user #{@current_user.displayed_name}"
          end

          @wish = wishes.first
          if @current_user.author_of?(@wish)
            edit_user_author_wish_path(@current_user, @wish, locale: @locale)
          else
            edit_user_my_wish_path(@current_user, @wish, locale: @locale)
          end
        else
          raise 'Edit Path not identified'
        end

      elsif m = page_name.match(/Skupina (.*)/)
        grp = Group.find_by(name: m[1])
        user_group_path(@current_user, grp, locale: @locale)

      elsif m = page_name.match(/přání uživatele (.*)/)
        user = User.find_by(name: m[1].delete('"').strip)
        user_my_wishes_path(user, locale: @locale)

      elsif m = page_name.match(/přání "(.*)"\z/)
        wishes = (@current_user.donee_wishes.where(title: m[1]).to_a + @current_user.donor_wishes.where(title: m[1]).to_a)
        if wishes.blank?
          raise "wish '#{m[1]}' was not found between wishes of user #{@current_user.displayed_name}"
        end

        user_my_wish_path(@current_user, wishes.first, locale: @locale)

      elsif m = page_name.match(/info pro "(.*)"/)
        user = User.find_by(name: m[1])
        raise "User with name '#{m[1]}' was not found between users" if user.blank?

        profile_infos_path(user, locale: @locale)
      else
        raise 'Path not identified'
      end
    end
  end

  def current_path
    URI.parse(current_url).path
  end
end

World(NavigationHelpers)
