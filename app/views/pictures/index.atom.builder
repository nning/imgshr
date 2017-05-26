atom_feed language: 'en-US' do |feed|
  feed.title 'Pictures on IMGSHR'
  feed.updated @pictures.first.created_at

  @pictures.each do |picture|
    url = absolute_url(picture_path(picture))
    feed.entry(picture, url: url) do |entry|
      entry.title('%s (%s)' % [picture, picture.gallery])
      entry.url(url)
      entry.updated(picture.created_at.strftime("%Y-%m-%dT%H:%M:%SZ"))
      entry.content \
        render(partial: 'galleries/feed_item_content_picture',
               locals: { picture: picture },
               formats: [:html]),
        type: 'html'
    end
  end
end
