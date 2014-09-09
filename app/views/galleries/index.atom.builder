atom_feed language: 'en-US' do |feed|
  feed.title 'Galleries on IMGSHR'
  feed.updated @galleries.first.last_update

  @galleries.each do |gallery|
    url = absolute_url(gallery_path(gallery))
    feed.entry(gallery, url: url) do |entry|
      entry.title(gallery)
      entry.url(url)
      entry.updated(gallery.last_update.strftime("%Y-%m-%dT%H:%M:%SZ")) 
      entry.content \
        render(partial: 'feed_item_content_gallery',
               locals: { gallery: gallery },
               formats: [:html]),
        type: 'html'
    end
  end
end
