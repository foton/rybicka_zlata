# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

porybny = User.new(name: 'porybny', email: 'porybny@rybickazlata.cz', password: 'Rybicka4Zlata', password_confirmation: 'Rybicka4Zlata', locale: 'cs', time_zone: 'Prague')
porybny.skip_confirmation!
porybny.save!
