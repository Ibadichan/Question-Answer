ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.question-edit').show();


$(document).on("turbolinks:load", ready);
