class Gallery < ActiveRecord::Base
  has_many :pictures, dependent: :destroy
  has_one :boss_token

  after_initialize do
    if new_record?
      self.slug ||= Base64.encode64(UUIDTools::UUID.random_create)[0..7]
      self.boss_token ||= BossToken.create!
    end
  end

  def increase_visits!
    update_column(:visits, visits + 1)
  end

  def last_update
    pictures.order('created_at desc').limit(1).first.updated_at
  rescue NoMethodError
    updated_at
  end

  def next_picture_id(id)
    i = picture_grid_ids.index(id) + 1
    picture_grid_ids[i]
  end

  def previous_picture_id(id)
    i = picture_grid_ids.index(id) - 1
    return nil if i < 0
    picture_grid_ids[i]
  end

  def to_param
    slug
  end

  def to_s
    name.blank? ? slug : name
  end

  private

  def picture_grid_ids
    @picture_grid_ids ||= pictures.grid.pluck(:id)
  end
end
