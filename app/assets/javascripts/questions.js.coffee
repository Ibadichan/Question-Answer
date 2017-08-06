$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.edit_question').show()

  voteAgainstOrForQuestion = (event, klassVotable, action) ->
    event.preventDefault()
    id = $(klassVotable).data('id')

    $.post "/questions/#{id}/#{action}", (data) ->
      votable = data['votable']
      rating = data['rating']
      html = JST['templates/questions/re_vote']( { votable: votable } )

      $('.question-rating').text("Рейтинг вопроса " + rating)
      $('.voting-of-question').html(html)

  $(document).on 'click', '.vote-for-question', (e) ->
    voteAgainstOrForQuestion(e, '.vote-for-question', 'vote_for' )

  $(document).on 'click', '.vote-against-question', (e) ->
    voteAgainstOrForQuestion(e, '.vote-against-question', 'vote_against')

  $(document).on 'click', '.re-vote-for-question', (e) ->
    e.preventDefault()
    id = $(this).data('id')

    $.ajax
      url: "/questions/#{id}/re_vote"
      type: "DELETE"
      success: (data) ->
        votable = data['votable']
        rating = data['rating']
        html = JST['templates/questions/voting_per_question']( {votable: votable } )

        $('.question-rating').text("Рейтинг вопроса " + rating)
        $('.voting-of-question').html(html)

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
        if data['user'] != gon.current_user
          html = JST['templates/answers/answer']({
            answer: data['answer'], question: data['question'],
            rating: data['answer_rating'], user: gon.current_user,
            attachments: data['attachments'], author: data['user']
          })

          $('.answers').append(html)
