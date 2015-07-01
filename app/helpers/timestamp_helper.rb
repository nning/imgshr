module TimestampHelper
  def timestamp(time, klass: :timestamp, tooltip: true)
    attrs = {title: time}
    attrs.merge!({data: {toggle: 'tooltip'}}) if tooltip

    content_tag(:span, attrs) do
      content_tag(:span, class: klass) do
        time.iso8601
      end
    end
  end

  def timestamp_ago(time, tooltip: true)
    timestamp(time, klass: :timestamp_ago, tooltip: tooltip)
  end
end
