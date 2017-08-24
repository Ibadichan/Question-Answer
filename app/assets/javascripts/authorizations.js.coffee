$ ->
  $(document).ajaxError (event, xhr, ajaxOptions, thrownError) ->
    type = xhr.getResponseHeader("content-type")
    return unless type
    if type.indexOf('text/javascript') >= 0
      $('p.alert').text(xhr.responseText)
    else if type.indexOf('application/json') >= 0
      $('p.alert').text($.parseJSON(xhr.responseText)['error'])
