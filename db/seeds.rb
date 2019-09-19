# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a default admin user =======================================================================================
puts 'CRIANDO USUARIO ADMINISTRADOR'
Admin.find_or_create_by!(email: 'admin@email.com') do |u|
  u.name = 'Super Admin'
  u.phone_number = '22 99999-9999'
  u.cpf = '23123412492'
  u.password = 'Prizma123!'
  u.password_confirmation = 'Prizma123!'
end
puts 'USUARIO ADMINISTRADOR CRIADO COM SUCESSO'

unless Rails.env.production?
  # Create a Landfill =================================================================================================
  Landfill.find_or_create_by!(name: 'Aterro de Gericinó') do |l|
    l.address = Address.create(
      street: 'Estrada do Gericinó',
      number: '',
      complement: '',
      district: 'Gericinó',
      city: 'Rio de Janeiro',
      state: 'Rio de Janeiro',
      country: 'Brasil',
      zip_code: '',
      latitude: '-22.8429971',
      longitude: '-43.4745312'
    )
  end

  # Create a default trucker user ===================================================================================
  puts 'CRIANDO USUARIO TRUCKER'
  Trucker.find_or_create_by!(email: 'trucker@email.com') do |u|
    u.password = '12345678'
    u.password_confirmation = '12345678'
    u.name = Faker::Name.name
    u.cpf = CpfUtils.cpf
    u.phone_number = Faker::PhoneNumber.phone_number
  end
  puts 'USUARIO TRUCKER CRIADO COM SUCESSO'

  # Create a default supervisor user ================================================================================
  puts 'CRIANDO USUARIO SUPERVISOR'
  Supervisor.find_or_create_by!(email: 'supervisor@email.com') do |u|
    u.password = '12345678'
    u.password_confirmation = '12345678'
    u.name = Faker::Name.name
    u.cpf = CpfUtils.cpf
    u.phone_number = Faker::PhoneNumber.phone_number
  end
  puts 'USUARIO SUPERVISOR CRIADO COM SUCESSO'

  # Create a default janitor user ===================================================================================
  puts 'CRIANDO USUARIO ZELADOR'
  Janitor.find_or_create_by!(email: 'zelador@email.com') do |u|
    u.password = '12345678'
    u.password_confirmation = '12345678'
    u.name = Faker::Name.name
    u.cpf = CpfUtils.cpf
    u.phone_number = Faker::PhoneNumber.phone_number
  end
  puts 'USUARIO ZELADOR CRIADO COM SUCESSO'

  # Create a default janitor user ===================================================================================
  puts 'CRIANDO USUARIO ATENDENTE'
  Clerk.find_or_create_by!(email: 'atendente@email.com') do |u|
    u.password = '12345678'
    u.password_confirmation = '12345678'
    u.name = Faker::Name.name
    u.cpf = CpfUtils.cpf
    u.phone_number = Faker::PhoneNumber.phone_number
  end
  puts 'USUARIO ATENDENTE CRIADO COM SUCESSO'

  # Create a default customer user ==================================================================================
  puts 'CRIANDO USUARIO CLIENT WITH ADDRESS'
  if Address.where(user: Client.find_by(email: 'client@email.com')).count == 0
    Address.create(
      street: 'Rua Emílio Wolf',
      number: '320',
      complement: 'Bloco 2, Apartamento: 405',
      district: 'Barra da Tijuca',
      city: 'Rio de Janeiro',
      state: 'RJ',
      country: 'Brasil',
      zip_code: '22783-225',
      user: Client.find_or_create_by!(email: 'client@email.com') do |u|
        u.password = '12345678'
        u.password_confirmation = '12345678'
        u.name = Faker::Name.name
        u.cpf = CpfUtils.cpf
        u.phone_number = Faker::PhoneNumber.phone_number
      end
    )
  end
  puts 'USUARIO CLIENT CRIADO COM SUCESSO'

  # Create a collect status requested ===============================================================================
  puts 'CRIANDO COLETA'
  Collect.all.destroy_all
  if Collect.all.count == 0
    Collect.create(
      status: 'requested',
      type_collect: 'rubble_collect',
      user: Client.last,
      address_id: Client.last.addresses.first.id
    )
  end
  puts 'COLETA CRIADA COM SUCESSO'

  # Create Contract ==================================================================================================
  puts 'CRIANDO CONTRATO'
  Contract.find_or_create_by!(name: 'Licitação Prefeitura de Townsville') do |contract|
    contract.observation = <<~HEREDOC
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
      quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
      Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
      Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    HEREDOC
  end
  puts 'CONTRATO CRIADO COM SUCESSO'
end
