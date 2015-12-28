class TempLink < ActiveRecord::Base
  include SlugAble

  belongs_to :picture
end
