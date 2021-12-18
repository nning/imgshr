Rails.application.reloader.to_prepare do
  Rails.application.config.active_storage.analyzers = [
    ImageExifAnalyzer
  ]
end
