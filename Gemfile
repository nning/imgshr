source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2.1'

gem 'rails', '~> 7.0.3'

gem 'acts-as-taggable-on', github: 'mbleigh/acts-as-taggable-on'
gem 'autoprefixer-rails'
gem 'best_in_place', github: 'mmotherwell/best_in_place'
gem 'bootsnap', require: false
gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'config'
gem 'dotiw', '< 5'
gem 'exifr'
gem 'hamlit'
gem 'image_processing'
gem 'jbuilder'
gem 'jquery-infinite-pages'
gem 'jquery-rails'
gem 'kaminari'
gem 'listen'
gem 'local_time'
gem 'mail'
gem 'mini_magick'
gem 'mysql2'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'puma', '~> 6'
gem 'psych', '< 6' # Necessary since update to Rails 7.0.3 and Ruby 3.1.2
gem 'rack-protection'
gem 'react-rails'
gem 'responders'
gem 'rqrcode'
gem 'sassc-rails'
gem 'secure_headers'
gem 'sidekiq', '~> 7.0.6'
gem 'sinatra'
gem 'sprockets', '~> 4'
gem 'uglifier'
gem 'webpacker'
gem 'yaml_db'

group :development do
  # gem 'better_errors'
  # gem 'binding_of_caller'
  # gem 'bullet'

  gem 'foreman'
  gem 'spring'
  gem 'web-console'
end

group :test do
  gem 'capybara_minitest_spec'
  gem 'capybara'
  # gem 'coveralls_reborn', require: false
  gem 'minitest-spec-rails'
  gem 'rexml' # For selenium-webdriver in Ruby 3
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery', '~> 2.2.4'
  gem 'rails-assets-seiyria-bootstrap-slider'
end
