namespace :galleries do
  desc 'Delete old, unused galleries'
  task :clean do
    require_relative '../../config/environment'

    ActiveRecord::Base.logger = Logger.new($stderr)

    now = Time.now

    if ENV['AGE'].nil?
      age = 1.month
    else
      age = ENV['AGE'].split.each_slice(2)
        .map { |x, y| x.to_i.send(y.to_sym) }.first
    end

    Gallery.where('created_at <= ?', (now - age)).each do |gallery|
      gallery.destroy! if gallery.pictures.count == 0
    end
  end
end
