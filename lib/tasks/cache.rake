namespace :cache do
  desc 'Clear cached view fragments'
  task :clear => :environment do
    Rails.cache.clear
  end
end
