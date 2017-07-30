$ ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    answerId =  $(this).parents('.answer-wrapper').data('answerId')
    $('form#edit_answer_'+ answerId).show()
    $(this).hide()

  voteAgainstOrForAnswer = (event, klassVotable, action) ->
      event.preventDefault()
      id = $(klassVotable).data('id')
      questionId = $(klassVotable).data('questionId')

      $.post "/questions/#{questionId}/answers/#{id}/#{action}", (data) ->
        votable = data['votable']
        rating = data['rating']
        html = JST['templates/answers/re_vote']( { votable: {id: votable.id, question: questionId } } )

        $(".answer-wrapper[data-answer-id=#{votable.id}] > .answer-rating").text("Рейтинг ответа " + rating)
        $(".answer-wrapper[data-answer-id=#{votable.id}] > .voting-of-answer").html(html)

  $(document).on 'click', '.vote-for-answer', (e) ->
    voteAgainstOrForAnswer(e, '.vote-for-answer', 'vote_for' )

  $(document).on 'click', '.vote-against-answer', (e) ->
    voteAgainstOrForAnswer(e, '.vote-against-answer', 'vote_against')

  $(document).on 'click', '.re-vote-for-answer', (e) ->
    e.preventDefault()
    id = $(this).data('id')
    questionId = $(this).data('questionId')

    $.ajax
      url: "/questions/#{questionId}/answers/#{id}/re_vote"
      type: "DELETE"
      success: (data) ->
        votable = data['votable']
        rating = data['rating']
        html = JST['templates/answers/voting_per_answer']( {votable: {id: votable.id, question: questionId }} )

        $(".answer-wrapper[data-answer-id=#{votable.id}] > .answer-rating").text("Рейтинг ответа " + rating)
        $(".answer-wrapper[data-answer-id=#{votable.id}] > .voting-of-answer").html(html)
