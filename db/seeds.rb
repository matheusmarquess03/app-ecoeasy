# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a default admin user ==================================================
puts 'CRIANDO USUARIO ADMINISTRADOR'
Admin.find_or_create_by!(email: 'admin@email.com') do |u|
  u.password = '12345678'
  u.password_confirmation = '12345678'
end
puts 'USUARIO ADMINISTRADOR CRIADO COM SUCESSO'

# Create a default trucker user ================================================
puts 'CRIANDO USUARIO TRUCKER'
Trucker.find_or_create_by!(email: 'trucker@email.com') do |u|
  u.password = '12345678'
  u.password_confirmation = '12345678'
  u.name = Faker::Name.name
  u.cpf = CpfUtils.cpf
  u.phone_number = Faker::PhoneNumber.phone_number
end
puts 'USUARIO TRUCKER CRIADO COM SUCESSO'

# Create a default customer user ===============================================
puts 'CRIANDO USUARIO CLIENT'
Client.find_or_create_by!(email: 'client@email.com') do |u|
  u.password = '12345678'
  u.password_confirmation = '12345678'
  u.name = Faker::Name.name
  u.cpf = CpfUtils.cpf
  u.phone_number = Faker::PhoneNumber.phone_number
end
puts 'USUARIO CLIENT CRIADO COM SUCESSO'

# Create a collect status requested ============================================
puts 'CRIANDO COLETA'
if Collect.all.count == 0
  Collect.create(
    collect_date: Date.today,
    status: 'requested',
    type_collect: 'rubble_collect'
  ).user << Client.last
end
puts 'COLETA CRIADA COM SUCESSO'
