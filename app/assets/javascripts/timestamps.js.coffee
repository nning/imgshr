$.fn.relatizeTimestamps = ->
  $(this).find('.timestamp').each ->
    $(this).text(moment($(this).text()).format('LLLL'))

  $(this).find('.timestamp_ago').each ->
    time = moment($(this).text())
    $(this).text(time.fromNow()).attr('title', time.format('LLLL'))

$ ->
  $('body').relatizeTimestamps()
