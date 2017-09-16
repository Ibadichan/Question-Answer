$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.edit_question').show()

  voting = (event, element, requestMethod) ->
    event.preventDefault()

    $.ajax
      url: element.attr('href')
      type: "#{requestMethod}"
      dataType: "JSON"
      success: (data) ->
        if element.attr('class') != 're-vote-for-question'
          html = JST['templates/questions/re_vote']({ votable: data['votable'] })
        else
          html = JST['templates/questions/voting_per_question']({ votable: data['votable'] })

        $('.question-rating').text("Рейтинг вопроса " + data['rating'])
        $('.voting-of-question').html(html)

  $(document).on 'click', '.vote-for-question', (e) ->
    voting(e, $(this), 'POST' )

  $(document).on 'click', '.vote-against-question', (e) ->
    voting(e, $(this), 'POST' )

  $(document).on 'click', '.re-vote-for-question', (e) ->
    voting(e, $(this),  'DELETE' )

  App.cable.subscriptions.create('QuestionsChannel', {
    received: (data) ->
      $('.questions-list').append(data)
  })
