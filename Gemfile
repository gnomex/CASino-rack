source 'https://rubygems.org'

ruby '2.1.3'

gem 'rails', '~> 4.1.6'
gem 'pg'

gem 'unicorn', '~> 4.8.2'
gem 'mina', '~> 0.3.0'
gem 'mina-unicorn', :require => false

gem 'rack-cas', '~> 0.9.2'

group :assets do
  gem 'sass-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'turbolinks'
  gem "therubyracer", "~> 0.12.1"
end

group :development do
  gem "pry", "~> 0.9.12.2"
  gem 'awesome_print', "~> 1.1.0"
end

group :development, :test do
  gem "rspec-rails", '2.14.1'
  gem 'capybara', '2.0.1'
  gem "factory_girl", "~> 4.4.0"
end
