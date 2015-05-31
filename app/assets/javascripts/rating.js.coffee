$('.rating').raty
  path: '/assets'
  score: ->
    $(this).attr('data-score')
  click: (score, _) ->
    alert 'ID: ' + $(this).attr('data-id') + "\nscore: " + score
