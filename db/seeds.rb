# Gallery, Picture
gallery = Gallery.create!

file = File.open(Rails.root.join('public/images/emsi.png'))

picture = gallery.pictures.build
picture.image_file.attach(io: file, filename: 'emsi.png')
picture.save!

# FileRelease
fr = FileRelease.new
fr.download.attach \
  io: File.open(Rails.root.join('README.md')),
  filename: 'README.md'
fr.version = 1
fr.branch = 'master'
fr.save!

# Print Gallery URL
Rails.logger = Logger.new($stdout)
Rails.logger.info "http://localhost:3000/!#{gallery.slug}"
