class TempLink < ApplicationRecord
  include SlugAble

  # TIMEOUT = Settings.dig(:temp_links, :invalidate_after) || 24.hours
  TIMEOUT = Settings.try(:temp_links).try(:invalidate_after) || 24.hours

  belongs_to :picture

  after_create :schedule_invalidation

  private

  def schedule_invalidation
    # TODO This does currently not work with `Settings.foreground_processing`.
    InvalidateTempLinks.set(wait: TIMEOUT).perform_later(self)
  end
end
