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
          html = JST['templates/answers/answer']({
            answer: data['answer'], question: data['question'],
            rating: data['answer_rating'], user: gon.current_user,
            attachments: data['attachments'], author: data['user']
          })

          $('.answers').append(html)

  $(document).on 'click', '.comments-link', (e) ->
    e.preventDefault()

    if $(this).hasClass('cancel')
      $(this).html('Комментарии')
    else
      $(this).html('Закрыть')

    $(this).toggleClass('cancel')
    $('.question-comments').toggle()

  $('.new_comment').bind 'ajax:success', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText)
    html = JST['templates/comments/comment']({ comment: comment })
    $('.question-comments').prepend(html)
    $('.new_comment #comment_body').val('')
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.question-wrapper .comment-errors').html('<p class="alert alert-danger">'+ value + '</p>')



