$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.edit_question').show()

  voting = (event, klassVotable, action, requestMethod) ->
    event.preventDefault()
    id = $(klassVotable).data('id')

    $.ajax
      url: "/questions/#{id}/#{action}"
      type: "#{requestMethod}"
      success: (data) ->
        if action != 're_vote'
          html = JST['templates/questions/re_vote']({ votable: data['votable'] })
        else
          html = JST['templates/questions/voting_per_question']({ votable: data['votable'] })

        $('.question-rating').text("Рейтинг вопроса " + data['rating'])
        $('.voting-of-question').html(html)

  $(document).on 'click', '.vote-for-question', (e) ->
    voting(e, '.vote-for-question', 'vote_for', 'POST' )

  $(document).on 'click', '.vote-against-question', (e) ->
    voting(e, '.vote-against-question', 'vote_against', 'POST' )

  $(document).on 'click', '.re-vote-for-question', (e) ->
    voting(e, '.re-vote-for-question', 're_vote', 'DELETE' )

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
        if ( gon.current_user == undefined ) or ( gon.current_user.id != data['user']['id'] )
          if data['answer']
            html = JST['templates/answers/answer']({
              answer: data['answer'], question: data['question'], user: gon.current_user,
              rating: data['answer_rating'], attachments: data['attachments'], author: data['user'],
            })
            $('.answers').append(html)

          else if data['comment']
            html = JST['templates/comments/comment']({ comment: data['comment']})
            $('.question-comments').append(html)
