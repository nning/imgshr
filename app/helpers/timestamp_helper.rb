module TimestampHelper
  def timestamp(time, relative: false, tooltip: true)
    props = {
      time: DateTime.parse(time.to_s).to_s,
      relative: relative,
      tooltip: tooltip
    }

    # react_component :Timestamp, props, prerender: true, tag: :span
    react_component :Timestamp, props, tag: :span
  end

  def timestamp_ago(time, tooltip: true)
    timestamp(time, relative: true, tooltip: tooltip)
  end

  def relative_distance_of_time_in_words(from, to)
    in_future = from > to
    suffix = in_future ? ' later' : ' before'

    distance_of_time_in_words(from, to, true, only: [:years, :months]) + suffix
  end

end
