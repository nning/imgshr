module ContentType
  def self.convert_format(request)
    accept = request.headers['Accept']

    if Settings.convert_to_avif && accept =~ /image\/avif/
      return 'image/avif'
    elsif Settings.convert_to_webp && accept =~ /image\/webp/
      return 'image/webp'
    else
      return false
    end
  end
end
