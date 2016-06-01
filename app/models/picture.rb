class Picture < ActiveRecord::Base
  belongs_to :gallery, touch: true

  has_many :ratings, dependent: :destroy
  has_many :temp_links, dependent: :destroy

  serialize :dimensions

  has_attached_file :image,
    styles: {medium: '850x850>', thumb: '200x200>'},
    url: '/system/:hash.:extension',
    hash_secret: Rails.application.secrets[:secret_key_base],
    processors: [:thumbnail, :paperclip_optimizer]

  if !::Settings.foreground_processing
    process_in_background :image, processing_image_url: '/images/missing/:style.png'
  end

  acts_as_taggable

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  # TODO Message currently not shown
  validates :image_fingerprint,
    uniqueness: {
      scope: :gallery_id,
      message: 'Picture already exists in gallery!'
    }

  after_image_post_process :set_height_and_width!
  after_image_post_process -> do
    set_exif_attributes
    set_order_date!
  end

  scope :by_order_date, -> { order('order_date desc') }
  scope :grid, -> { by_order_date }

  scope :since, ->(date) { where('order_date >  ?', Date.parse(date)) }
  scope :until, ->(date) { where('order_date <= ?', Date.parse(date)) }

  scope :min_rating, ->(score) { joins(:ratings).where('ratings.score >= ?', score) }
  scope :max_rating, ->(score) { joins(:ratings).where('ratings.score <= ?', score) }

  paginates_per 12

  def average_rating
    (ratings.sum(:score) / ratings.size.to_f).round(2)
  end

  def height(size = :original)
    dimensions[size][:height] rescue nil
  end

  def image_fingerprint_short
    @image_fingerprint_short ||= image_fingerprint[0..7]
  end

  def photographed_or_created_at
    photographed_at || created_at
  end

  # TODO Referal of pictures by fingerprint assumes they are unique. Actually,
  #      we also need a slug, here.
  def to_param
    image_fingerprint_short
  end

  def to_s
    title.blank? ? 'Untitled picture' : title
  end

  def width(size = :original)
    dimensions[size][:width] rescue nil
  end

  def self.filtered(params)
    pictures = all

    # Tags
    pictures = pictures.tagged_with(params[:tags]) unless params[:tags].blank?

    # Since date
    pictures = pictures.since(params[:since]) unless params[:since].blank?

    # Until date
    pictures = pictures.until(params[:until]) unless params[:until].blank?

    # Minimum rating
    pictures = pictures.min_rating(params[:min_rating]) unless params[:min_rating].blank?

    # Maximum rating
    pictures = pictures.max_rating(params[:max_rating]) unless params[:max_rating].blank?

    pictures
  end

  def self.first_by_fingerprint!(fp)
    if fp.size == 8
      where('image_fingerprint like ?', "#{fp}%").first!
    else
      find_by_image_fingerprint!(fp)
    end
  end

  def self.neighbor_id(picture, d)
    ids = pluck(:id)

    begin
      i = ids.index(picture.id) + d
    rescue NoMethodError
      return nil
    end

    return nil if i < 0 || i > ids.size

    ids[i]
  end

  def self.next_id(picture)
    self.neighbor_id(picture, 1)
  end

  def self.previous_id(picture)
    self.neighbor_id(picture, -1)
  end

  private

  def exif_camera_string(exif)
    camera = exif.model

    if !(exif.make.blank? || camera.starts_with?(exif.make))
      camera = [exif.make, camera].join(' ')
    end

    camera
  end

  def set_exif_attributes
    exif = nil

    path = begin
      image.queued_for_write[:original].path
    rescue NoMethodError
      image.path
    end

    begin
      exif = EXIFR::JPEG.new(path)
    rescue EXIFR::MalformedJPEG
    end

    set_exif_values(exif) if exif && exif.exif?
  end

  def set_exif_values(exif)
    self.camera = exif_camera_string(exif)
    self.photographed_at = exif.date_time_digitized

    unless exif.focal_length.nil?
      self.focal_length  = exif.focal_length.to_f.round(3)
    end

    self.aperture      = exif.aperture_value || exif.f_number
    self.shutter_speed = exif.shutter_speed_value || exif.exposure_time
    self.iso_speed     = exif.iso_speed_ratings
    self.flash         = exif.flash

    exif
  end

  def set_height_and_width!
    self.dimensions = {}

    hash = image.queued_for_write

    if hash.empty?
      hash = {}
      %i[original medium thumb].each do |size|
        hash[size] = image.path(size)
      end
    end
    
    hash.each do |size, file|
      geometry = Paperclip::Geometry.from_file(file)
      self.dimensions[size] = {
        width:  geometry.width.to_i,
        height: geometry.height.to_i
      }
    end
  end

  def set_order_date!
    if self.photographed_at?
      self.order_date = self.photographed_at
    elsif self.created_at?
      self.order_date = self.created_at
    else
      # order_date should be set to created_at but that's not available in
      # before_create. Time.now should be close enough.
      self.order_date = Time.now
    end

    true
  end
end
