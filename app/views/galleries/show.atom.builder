atom_feed language: 'en-US' do |feed|
  feed.title @gallery.to_s + ' (IMGSHR)'
  feed.updated @gallery.last_update

  @feed_pictures.each do |picture|
    url = absolute_url(gallery_picture_path(@gallery, picture))
    feed.entry(picture, url: url) do |entry|
      entry.title(picture)
      entry.url(url)
      entry.updated(picture.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 
      entry.content(feed_item_content(picture), type: 'html')
    end
  end
end
