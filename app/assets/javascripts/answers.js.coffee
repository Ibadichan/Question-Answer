$ ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    answerId =  $(this).parents('.answer-wrapper').data('answerId')
    $('form#edit_answer_'+ answerId).show()
    $(this).hide()

  voting = (event, element, klassVotable, action, requestMethod) ->
    event.preventDefault()
    id = element.data('id')

    $.ajax
      url: "/answers/#{id}/#{action}"
      type: "#{requestMethod}"
      success: (data) ->
        if action != 're_vote'
          html = JST['templates/answers/re_vote']({ votable: data['votable'] })
        else
          html = JST['templates/answers/voting_per_answer']({ votable: data['votable'] })

        answerWrapper = ".answer-wrapper[data-answer-id=#{ data['votable']['id'] }]"

        $(answerWrapper + " > .answer-rating").text("Рейтинг ответа " + data['rating'])
        $(answerWrapper + " > .voting-of-answer").html(html)

  $(document).on 'click', '.vote-for-answer', (e) ->
    voting(e, $(this), '.vote-for-answer', 'vote_for', 'POST' )

  $(document).on 'click', '.vote-against-answer', (e) ->
    voting(e, $(this), '.vote-against-answer', 'vote_against', 'POST' )

  $(document).on 'click', '.re-vote-for-answer', (e) ->
    voting(e, $(this), '.re-vote-for-answer', 're_vote', 'DELETE' )

  $(document).on 'click', '.comments-link[data-commentable="answer"]', ->
    App.cable.subscriptions.create { channel: 'AnswersChannel', answer_id: $(this).data('id') },
      connected: ->
        @perform 'follow_for_answer'
      received: (data) ->
        if ( gon.current_user == undefined ) or ( gon.current_user.id != data['user']['id'] )
          if data['comment']
            commentableId = data['comment']['commentable_id']

            html = JST['templates/comments/comment']({ comment: data['comment']})
            $(".answer-comments[data-id='#{commentableId}']").append(html)
