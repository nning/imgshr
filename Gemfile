source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.6.0'

gem 'bundler', '>= 1.8.4'
gem 'rails', '~> 5.2.0.rc1'

gem 'acts-as-taggable-on', github: 'nning/acts-as-taggable-on', branch: 'rails-5.2-process_dirty_object'
gem 'autoprefixer-rails'
gem 'best_in_place'
gem 'bootsnap', require: false
gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'config'
gem 'dotiw'
gem 'exifr'
gem 'hamlit'
gem 'image_processing'
gem 'jbuilder'
gem 'jquery-infinite-pages'
gem 'jquery-rails'
gem 'kaminari'
gem 'local_time'
gem 'mail'
gem 'mini_magick'
gem 'mysql2'
gem 'omniauth-github'
gem 'puma'
gem 'rack-protection'
gem 'react-rails'
gem 'responders'
gem 'rqrcode'
gem 'sassc-rails'
gem 'secure_headers'
gem 'sidekiq'
gem 'sinatra'
gem 'uglifier'
gem 'webpacker'
gem 'yaml_db'

# Keep paperclip around for migration to ActiveStorage
gem 'paperclip'

group :development do
  # gem 'better_errors'
  # gem 'binding_of_caller'
  # gem 'bullet'

  gem 'foreman'
  gem 'listen'
  gem 'spring-watcher-listen'
  gem 'spring'
  gem 'web-console'
end

group :production do
  gem 'skylight'
end

group :test do
  gem 'capybara_minitest_spec'
  gem 'capybara'
  gem 'chromedriver-helper'
  gem 'coveralls', require: false
  gem 'minitest-spec-rails'
  gem 'selenium-webdriver'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery', '~> 3.4.1'
  gem 'rails-assets-jquery-cookie'
  gem 'rails-assets-momentjs'
  gem 'rails-assets-seiyria-bootstrap-slider'
end
