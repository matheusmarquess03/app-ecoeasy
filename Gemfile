source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.2'


# Essential Gems ###############################################################
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.1'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Assets Gems ##################################################################
gem 'bootstrap', '~> 4.1.3'
gem 'bootstrap_sb_admin_base_v2'
gem 'bootstrap-modal-rails'
gem 'cocoon'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# Integrations Gems ############################################################
gem 'aws-sdk-s3', require: false
gem 'devise'
gem 'devise-i18n'
gem 'devise_token_auth'
gem 'firebase'
gem 'rack-attack'
gem 'rack-cors'

# Utils Gems ###################################################################
gem 'cpf_utils'
gem 'faker'
gem 'image_processing', '~> 1.2'


# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development


# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-rails', '~> 0.3.4'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'letter_opener'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end
