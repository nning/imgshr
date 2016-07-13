class InvalidateTempLinks < ApplicationJob
  queue_as :temp_link_invalidation

  def perform(temp_link)
    TempLink.find_by_slug!(temp_link.slug).destroy!
  end
end
