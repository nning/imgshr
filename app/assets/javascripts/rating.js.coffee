box       = $('.rating')
old_score = box.attr('data-score')
url       = box.attr('data-uri')

box.raty
  path: '/images'
  score: old_score
  click: (score, _) ->
    box.find('img').unbind('click')

    $.ajax
      type: 'post'
      url: url
      data:
        picture:
          score: score
      success: ->
        $.ajax
          type: 'get'
          url: url
          success: (data) ->
            box.raty('score', data)
            box.raty('readOnly', true)
          error: ->
            box.raty('score', old_score)
      error: ->
        box.raty('score', old_score)
