class Rating < ActiveRecord::Base
  belongs_to :picture, touch: true

  validates :score, inclusion: { in: 1..5 }
end
