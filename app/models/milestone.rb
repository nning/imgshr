class Milestone < ApplicationRecord
  belongs_to :gallery

  scope :by_time, -> { order('time asc') }
  scope :show_on_pictures, -> { where(show_on_pictures: true) }

  validates :time, :description, presence: true
end
