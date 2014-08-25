namespace :db do
  desc 'Reset and seed database'
  task :reset do
    Rake::Task['db:migrate:reset'].invoke
    Rake::Task['db:seed'].invoke
  end
end
