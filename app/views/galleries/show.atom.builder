atom_feed language: 'en-US' do |feed|
  feed.title @gallery.to_s + ' (IMGSHR)'
  feed.updated @gallery.last_update

  @feed_pictures.each do |picture|
    feed.entry(picture, url: picture_url(@gallery.slug, picture)) do |entry|
      entry.url(absolute_url(picture.image.url))
      entry.title(picture)
      entry.content(image_tag(picture.image.url(:medium), title: picture), type: 'html')
      entry.updated(picture.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 
    end
  end
end
