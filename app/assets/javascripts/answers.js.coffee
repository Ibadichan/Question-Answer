ready = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    answerId =  $(this).parents('.answer-wrapper').data('answerId');
    $('form#edit_answer_'+ answerId).show();
    e.preventDefault();
    $(this).hide();

$(document).on('turbolinks:load', ready);
