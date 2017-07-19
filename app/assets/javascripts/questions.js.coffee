ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();


$(document).on("turbolinks:load", ready);
