$ ->
  $(document).on 'click', '.comments-link', (e) ->
    e.preventDefault()

    if $(this).hasClass('cancel')
      $(this).html('Комментарии')
    else
      $(this).html('Закрыть')
    $(this).toggleClass('cancel')

    $(this).next().toggle()
    $(this).nextAll('form#new_comment').toggle()

  $(document).on 'submit', 'form.new_comment', (e) ->
    e.preventDefault()
    form = $(this)
    $('p.alert, p.notice').html('')

    $.post(form.attr('action'), form.serialize(), (data) ->
      form.find('.comment-errors').html('')
      form.prev().prev().append( JST['templates/comments/comment']({ comment: data }))
      form.find('input[type="submit"]').removeAttr('disabled')
      $('.new_comment #comment_body').val('')
      $('p.notice').html('Comment успешно создан.')
    'json').fail( (data) ->
      $('p.alert').html('Comment не может быть создан.')
      $.each $.parseJSON(data.responseText)['errors'], (index, value) ->
        form.find('.comment-errors').append('<p class="alert alert-danger">'+ value + '</p>')
      form.find('input[type="submit"]').removeAttr('disabled')
    'json')

  if  $('.question-wrapper').length == 1
    App.cable.subscriptions.create {
      channel: 'CommentsChannel', question_id: $('.question-wrapper').data('questionId')
      },
      connected: ->
        @perform 'follow'
      received: (data) ->
        if ( gon.current_user == undefined ) or ( gon.current_user.id != data['author']['id'])
          html = JST['templates/comments/comment']({ comment: data['comment']})
          type = data['comment']['commentable_type'].toLowerCase()
          id = data['comment']['commentable_id']
          $(".#{type}-comments[data-id='#{id}']").append(html)
