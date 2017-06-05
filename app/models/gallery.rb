class Gallery < ApplicationRecord
  include BossTokenAble::Model
  include SlugAble

  has_many :pictures, dependent: :destroy
  has_many :device_links, dependent: :destroy

  def increase_visits!
    update_column(:visits, visits + 1)
  end

  def last_update
    v   = pictures.order('updated_at desc').limit(1).pluck(:updated_at).first
    v ||= updated_at
    v
  end

  def to_s
    name.blank? ? slug : name
  end
end
