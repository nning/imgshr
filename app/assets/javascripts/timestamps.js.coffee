$.fn.relatizeTimestamps = ->
  $(this).find('.timestamp').each ->
    time = moment($(this).text())
    if time.isValid()
      $(this).text(time.format('LLLL'))

  $(this).find('.timestamp_ago').each ->
    time = moment($(this).text())
    if time.isValid()
      $(this).text(time.fromNow()).attr('title', time.format('LLLL'))

$(document).on 'content:update', ->
  $('body').relatizeTimestamps()
	$('[data-toggle="tooltip"]').tooltip
    trigger: 'click hover focus'
