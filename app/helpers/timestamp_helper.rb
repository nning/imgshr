module TimestampHelper
  def timestamp(time, klass: :timestamp, tooltip: true)
    attrs = {title: time}
    attrs.merge!({data: {toggle: 'tooltip'}}) if tooltip

    content_tag(:span, attrs) do
      content_tag(:span, class: klass) do
        DateTime.parse(time.to_s).to_s
      end
    end
  end

  def timestamp_ago(time, tooltip: true)
    timestamp(time, klass: :timestamp_ago, tooltip: tooltip)
  end

  def relative_distance_of_time_in_words(from, to)
    in_future = from > to
    suffix = in_future ? ' later' : ' before'

    distance_of_time_in_words(from, to, true, only: [:years, :months]) + suffix
  end

end
