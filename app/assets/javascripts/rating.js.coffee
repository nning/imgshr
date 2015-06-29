$(document).on 'page:change', ->
  $('.rating').raty
    path: '/images'
    score: ->
      $(this).attr('data-score')
    click: (score, _) ->
      box       = $(this)
      old_score = box.attr('data-score')
      url       = box.attr('data-uri')

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
