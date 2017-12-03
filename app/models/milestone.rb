class Milestone < ApplicationRecord
  belongs_to :gallery

  scope :by_time, -> { order('time asc') }

  validates :time, :description, presence: true
end
