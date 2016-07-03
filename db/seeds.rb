# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

phone_number = '0999607901'
first_name = 'Ernest'
last_name = 'Matola'
nick_name = 'mangochiman'
role = 'admin'

user = User.new
user.phone_number = phone_number
user.first_name = first_name
user.last_name = last_name
user.nick_name = nick_name
user.save!


user_role = UserRole.new
user_role.user_id = user.user_id
user_role.role = role
user_role.save