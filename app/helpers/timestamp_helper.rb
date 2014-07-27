module TimestampHelper
  def timestamp(time)
    content_tag :span, time.iso8601, class: :timestamp
  end

  def timestamp_ago(time)
    content_tag :span, time.iso8601, class: :timestamp_ago
  end
end
