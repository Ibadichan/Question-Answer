ready = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    answer_id =  $(this).parents('.answer-wrapper').data('answerId');
    $('form#edit_answer_'+ answer_id).show();
    e.preventDefault();
    $(this).hide();

$(document).on('turbolinks:load', ready);
