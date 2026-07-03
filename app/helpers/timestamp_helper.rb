module TimestampHelper
  def timestamp(time, relative: false, tooltip: true)
    t = time.is_a?(Time) ? time : Time.parse(time.to_s)

    if relative
      text = time_ago_in_words(t) + ' ago'
    else
      text = t.strftime('%Y-%m-%d %H:%M:%S (%z)')
    end

    title = t.strftime('%Y-%m-%d %H:%M:%S (%A)')

    attrs = { class: 'timestamp', title: title }
    attrs[:'data-toggle'] = 'tooltip' if tooltip

    content_tag(:span, text, attrs)
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
