$ ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    answerId =  $(this).parents('.answer-wrapper').data('answerId')
    $('form#edit_answer_'+ answerId).show()
    $(this).hide()

  voting = (event, element, requestMethod) ->
    event.preventDefault()

    $.ajax
      url: element.attr('href')
      type: "#{requestMethod}"
      dataType: "JSON"
      success: (data) ->
        if element.attr('class') != 're-vote-for-answer'
          html = JST['templates/answers/re_vote']({ votable: data['votable'] })
        else
          html = JST['templates/answers/voting_per_answer']({ votable: data['votable'] })

        id = data['votable']['id']
        $(".answer-rating[data-id='#{id}']").text("Рейтинг ответа " + data['rating'])
        $(".voting-of-answer[data-id='#{id}']").html(html)

  $(document).on 'click', '.vote-for-answer', (e) ->
    voting(e, $(this), 'POST')

  $(document).on 'click', '.vote-against-answer', (e) ->
    voting(e, $(this), 'POST')

  $(document).on 'click', '.re-vote-for-answer', (e) ->
    voting(e, $(this), 'DELETE' )

  if $('.question-wrapper').length == 1
    App.cable.subscriptions.create {
      channel: 'AnswersChannel', question_id: $('.question-wrapper').data('questionId')
    },
      received: (data) ->
        if ( gon.current_user == undefined ) or ( gon.current_user.id != data['author']['id'] )
          html = JST['templates/answers/answer']({
            answer: data['answer'], question: data['question'], user: gon.current_user,
            rating: data['answer_rating'], attachments: data['attachments'], author: data['author'],
          })
          $('.answers').append(html)
