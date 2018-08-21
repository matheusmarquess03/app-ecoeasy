# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a default admin user ==================================================
Admin.find_or_create_by!(email: 'admin@email.com') do |u|
  u.name = 'Super Admin'
  u.password = '12345678'
  u.password_confirmation = '12345678'
end

# Create a default trucker user ================================================
User.find_or_create_by!(email: 'trucker@email.com') do |u|
  u.password = '12345678'
  u.password_confirmation = '12345678'
  u.access_profile = 'trucker'
  u.name = Faker::Name.name
  u.cpf = CpfUtils.cpf
  u.phone_number = Faker::PhoneNumber.phone_number
end

# Create a default customer user ===============================================
User.find_or_create_by!(email: 'customer@email.com') do |u|
  u.password = '12345678'
  u.password_confirmation = '12345678'
  u.access_profile = 'customer'
  u.name = Faker::Name.name
  u.cpf = CpfUtils.cpf
  u.phone_number = Faker::PhoneNumber.phone_number
end
