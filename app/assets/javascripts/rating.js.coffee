$('.rating').raty
  path: '/assets'
  score: ->
    $(this).attr('data-score')
  click: (score, _) ->
    self = $(this)
    url  = self.attr('data-uri')

    self.find('img').unbind('click')

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
            self.raty('score', data)
            self.raty('readOnly', true)
