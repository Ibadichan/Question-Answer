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
