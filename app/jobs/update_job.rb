class UpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    system(Rails.root.join('update.sh').to_s)
  end
end
