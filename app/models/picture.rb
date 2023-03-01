require Rails.root.join('app/validators/picture_image_validator')

class Picture < ApplicationRecord
  include MetadataDelegator

  belongs_to :gallery, touch: true

  has_many :ratings, dependent: :destroy
  has_many :temp_links, dependent: :destroy

  has_one_attached :image_file

  acts_as_taggable_on :tags, :labels

  validates_with PictureImageValidator

  before_save :set_fallback_order_date

  before_save :update_order_date, if: :will_save_change_to_ignore_exif_date?

  if !::Settings.foreground_processing && LabelImage.is_enabled?
    # TODO after_image_post_process without delay
    after_create :enqueue_label_job
  end

  scope :by_order_date, -> { order('order_date desc') }
  scope :by_created_at, -> { order('created_at desc') }

  scope :by_order_date_reverse, -> { order('order_date asc') }
  scope :by_created_at_reverse, -> { order('created_at asc') }

  scope :since, ->(date) { where('order_date >  ?', Date.parse(date)) }
  scope :until, ->(date) { where('order_date <= ?', Date.parse(date)) }

  scope :min_rating, ->(score) { joins(:ratings).where('ratings.score >= ?', score) }
  scope :max_rating, ->(score) { joins(:ratings).where('ratings.score <= ?', score) }

  paginates_per 16

  delegate_to_metadata :photographed_at, :camera, :focal_length, :aperture,
    :shutter_speed, :iso_speed, :flash, :height, :width, :software, :hdr

  def average_rating
    (ratings.sum(:score) / ratings.count.to_f).round(2)
  end

  def photographed_or_created_at
    photographed_at || created_at
  end

  # TODO Referal of pictures by fingerprint assumes they are unique. Actually,
  #      we also need a slug, here.
  def to_param
    image_file.key
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

  def preprocess_variants!
    Settings.sizes.each do |size, options|
      additional_options = {}
      additional_options[:convert] = 'webp' if Settings.convert_to_webp
      additional_options[:convert] = 'avif' if Settings.convert_to_avif
      options.merge!(additional_options)

      image_file.variant(**options).processed
    end
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

  def self.first_by_key!(key)
    with_attached_image_file
      .references(:attachment_image_file)
      .where(ActiveStorage::Blob.arel_table[:key].matches(key))
      .first!
  end

  private

  def enqueue_label_job
    LabelImageJob.set(wait: 25.seconds).perform_later(self)
  end

  def set_fallback_order_date
    self.order_date ||= self.created_at || Time.now
  end

  def update_order_date
    date = created_at

    unless ignore_exif_date
      date = image_file.metadata[:photographed_at] || created_at
    end

    update_columns(order_date: date)
  end
end
