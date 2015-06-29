module TimestampHelper
  def timestamp(time, klass: :timestamp)
    content_tag(:span, title: time, data: {toggle: 'tooltip'}) do
      content_tag(:span, class: klass) do
        time.iso8601
      end
    end
  end

  def timestamp_ago(time)
    timestamp(time, klass: :timestamp_ago)
  end
end
