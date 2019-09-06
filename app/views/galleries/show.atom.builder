cache [@gallery, :feed] do
  atom_feed language: 'en-US' do |feed|
    feed.title @gallery.to_s + ' (IMGSHR)'
    feed.updated @gallery.last_update

    @feed_pictures.each do |picture|
      url = absolute_url_for(picture_path(picture))

      feed.entry(picture, url: url) do |entry|
        entry.title(picture)
        entry.url(url)
        entry.updated(picture.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))

        entry.link \
          href: absolute_url_for(picture.image_file),
          rel: 'enclosure',
          type: picture.image_file.content_type

        entry.content \
          render(partial: 'feed_item_content_picture',
                 locals: { picture: picture },
                 formats: [:html]),
          type: 'html'
      end
    end
  end
end
