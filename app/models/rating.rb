class Rating < ActiveRecord::Base
  belongs_to :picture

  validates :score, inclusion: { in: 1..5 }
end
