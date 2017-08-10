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

    $.post(form.attr('action'), form.serialize(), (data) ->
      form.find('.comment-errors').html('')
      form.prev().prev().append( JST['templates/comments/comment']({ comment: data }))
      form.find('input[type="submit"]').removeAttr('disabled')
      $('.new_comment #comment_body').val('')
    ).fail( (error) ->
      errorComment = $.parseJSON(error.responseText)['body'][0]
      form.find('.comment-errors').html('<p class="alert alert-danger">'+ errorComment + '</p>')
      form.find('input[type="submit"]').removeAttr('disabled')
    )
