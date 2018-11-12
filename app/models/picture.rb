require Rails.root.join('app/validators/picture_image_validator')

class Picture < ApplicationRecord
  include MetadataDelegator

  belongs_to :gallery, touch: true

  has_many :ratings, dependent: :destroy
  has_many :temp_links, dependent: :destroy

  has_one_attached :image_file

  # TODO Remove after successful migration to ActiveStorage?
  has_attached_file :image,
    styles: {medium: '850x850>', thumb: '200x200>'},
    url: '/system/:hash.:extension',
    hash_secret: Rails.application.secrets[:secret_key_base]

  acts_as_taggable_on :tags, :labels

  validates_with PictureImageValidator

  validates :image_fingerprint,
    uniqueness: {
      scope: :gallery_id,
      message: 'Picture already exists in gallery!'
    }

  after_create :set_image_fingerprint!

  if !::Settings.foreground_processing && LabelImage.is_enabled?
    # TODO after_image_post_process without delay
    after_create :enqueue_label_job
  end

  scope :by_order_date, -> { order('order_date desc') }
  scope :by_created_at, -> { order('created_at desc') }

  scope :since, ->(date) { where('order_date >  ?', Date.parse(date)) }
  scope :until, ->(date) { where('order_date <= ?', Date.parse(date)) }

  scope :min_rating, ->(score) { joins(:ratings).where('ratings.score >= ?', score) }
  scope :max_rating, ->(score) { joins(:ratings).where('ratings.score <= ?', score) }

  paginates_per 12

  delegate_to_metadata :photographed_at, :camera, :focal_length, :aperture,
    :shutter_speed, :iso_speed, :flash, :height, :width

  def average_rating
    (ratings.sum(:score) / ratings.count.to_f).round(2)
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

  def label_image!
    ds = ActiveStorage::Service::DiskService.new(root: Rails.root.join('storage'))
    path = ds.send(:path_for, self.image_file.blob.key)

    process = LabelImage::Process.new(path)
    raw_label_list = process.run!

    self.raw_label_list = raw_label_list.to_json
    self.label_list = process.labels_above_threshold

    save!
  end

  def raw_label_list_hash
    JSON.parse(raw_label_list)
  end

  def plain?
    gallery && !gallery.client_encrypted
  end

  def self.filtered(params)
    pictures = all

    # Untagged
    pictures = pictures.tagged_with(ActsAsTaggableOn::Tag.all.map(&:to_s), exclude: true) unless params[:untagged].blank?

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

  private

  def set_image_fingerprint!
    update_attributes! \
      image_fingerprint: Digest::MD5.hexdigest(self.image_file.download)
  end

  def enqueue_label_job
    LabelImageJob.set(wait: 25.seconds).perform_later(self)
  end
end
