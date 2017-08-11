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
    connected: ->
      @perform 'follow'
    received: (data) ->
      $('.questions-list').append(data)
  })

  if $('.answers').length == 1
    App.cable.subscriptions.create {
      channel: 'QuestionsChannel', question_id: $('.question-wrapper').data('questionId')
      },
      connected: ->
        @perform 'follow_for_question'
      received: (data) ->
        if ( gon.current_user == undefined ) or ( gon.current_user.id != data['author']['id'] )
          html = JST['templates/answers/answer']({
            answer: data['answer'], question: data['question'], user: gon.current_user,
            rating: data['answer_rating'], attachments: data['attachments'], author: data['author'],
          })
          $('.answers').append(html)
