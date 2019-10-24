source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.6.0'

gem 'bundler', '>= 1.8.4'
gem 'rails', '~> 5.2.3.0'

gem 'acts-as-taggable-on', github: 'nning/acts-as-taggable-on', branch: 'rails-5.2-process_dirty_object'
gem 'autoprefixer-rails'
gem 'best_in_place', '>= 3.1.1'
gem 'bootsnap', require: false
gem 'bootstrap-sass'
gem 'coffee-rails', '>= 5.0.0'
gem 'config'
gem 'dotiw', '>= 4.0.1'
gem 'exifr'
gem 'hamlit'
gem 'image_processing'
gem 'jbuilder'
gem 'jquery-infinite-pages', '>= 0.2.0'
gem 'jquery-rails', '>= 4.3.5'
gem 'kaminari', '>= 1.1.1'
gem 'local_time'
gem 'mail'
gem 'mini_magick'
gem 'mysql2'
gem 'omniauth-github'
gem 'puma'
gem 'rack-protection'
gem 'react-rails', '>= 2.6.0'
gem 'responders', '>= 3.0.0'
gem 'rqrcode'
gem 'sassc-rails', '>= 2.1.2'
gem 'secure_headers'
gem 'sidekiq', '~> 5.2.7'
gem 'sinatra'
gem 'uglifier'
gem 'webpacker', '>= 4.0.7'
gem 'yaml_db', '>= 0.7.0'

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
  gem 'web-console', '>= 3.7.0'
end

group :production do
  gem 'skylight'
end

group :test do
  gem 'capybara_minitest_spec'
  gem 'capybara'
  gem 'webdrivers'
  gem 'coveralls', require: false
  gem 'minitest-spec-rails', '>= 6.0.0'
  gem 'selenium-webdriver'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery', '~> 2.2.4'
  gem 'rails-assets-jquery-cookie'
  gem 'rails-assets-momentjs'
  gem 'rails-assets-seiyria-bootstrap-slider'
end
