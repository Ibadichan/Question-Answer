
ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();
  $('.vote-for-question, .vote-against-question').bind 'ajax:success', (e, status, data, xhr) ->
    rating = $.parseJSON(xhr.responseText)
    $('.question-rating').text("Рейтинг вопроса " + rating)


$(document).on("turbolinks:load", ready);
