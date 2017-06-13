require 'open-uri'

URLS = [
  'https://storage.googleapis.com/download.tensorflow.org/models/inception_v3_2016_08_28_frozen.pb.tar.gz'
]
DIR = 'lib/label_image'

namespace :label_image do
  desc 'Update label_image dependencies'
  task :update do
    URLS.each do |url|
      path = File.join(DIR, File.basename(url))

      open(path, 'wb') do |file|
        file << open(url).read
      end

      `tar xzf #{path} -C #{DIR} && rm #{path}`
    end
  end
end
