cache [@file_releases.first, :feed] do
  atom_feed language: 'en-US' do |feed|
    feed.title 'IMGSHR Releases'
    feed.updated @file_releases.first.updated_at

    @file_releases.each do |release|
      url = absolute_url_for(release.file.url)

      feed.entry(release, url: url) do |entry|
        entry.title(release)
        entry.url(url)
        entry.updated(release.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))
        entry.link href: url, rel: 'enclosure', type: release.file.content_type
      end
    end
  end
end
