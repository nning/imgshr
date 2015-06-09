$('.rating').raty
  path: '/assets'
  score: ->
    $(this).attr('data-score')
  click: (score, _) ->
    $.ajax
      type: 'post',
      url: $(this).attr('data-uri'),
      data:
        picture:
          score: score
    $(this).find('img').unbind('click')
