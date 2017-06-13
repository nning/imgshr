require 'open-uri'

URL = 'https://storage.googleapis.com/download.tensorflow.org/models/inception_v3_2016_08_28_frozen.pb.tar.gz'
DIR = 'lib/label_image'

def async?
  ENV['ASYNC_LABEL_IMAGE'].present?
end

def skip?(picture)
  return false if ENV['FORCE_LABEL_IMAGE'].present?
  !picture.label_list.empty?
end

namespace :label_image do
  desc 'Update label_image dependencies'
  task :update do
    path = File.join(DIR, File.basename(URL))

    open(path, 'wb') do |file|
      file << open(URL).read
    end

    `tar xzf #{path} -C #{DIR} && rm #{path}`
  end

  desc 'Auto-label images'
  task :refresh do
    require_relative '../../config/environment'

    Picture.find_each do |picture|
      next if skip?(picture)

      if async?
        picture.send(:enqueue_label_job)
      else
        picture.label_image!
        puts picture.image_fingerprint_short
      end
    end
  end
end
