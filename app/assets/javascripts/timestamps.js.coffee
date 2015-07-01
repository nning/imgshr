$.fn.relatizeTimestamps = ->
  $(this).find('.timestamp').each ->
    time = moment($(this).text())
    if time.isValid()
      $(this).text(time.format('LLLL'))

  $(this).find('.timestamp_ago').each ->
    time = moment($(this).text())
    if time.isValid()
      $(this).text(time.fromNow()).attr('title', time.format('LLLL'))

$(document).on 'page:change', ->
  $('body').relatizeTimestamps()
	$('[data-toggle="tooltip"]').tooltip
    trigger: 'click hover focus'
