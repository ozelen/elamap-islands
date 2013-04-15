$ ->
  $('.nav-tabs a').click( (e) ->
    e.preventDefault()
    $(this).tab('show')
  )
  $('.nav-tabs a:first').tab('show')


  $('.nav-tabs a#map_tab').click( (e) ->
    e.preventDefault()
    $(this).tab('show')
    url = $(this).attr('url')

    $('<img src="' + url + '">').load( ->
      console.log this.height
      initMap('session-map', url, this.width, this.height)
    ).error( ->
      $('session-map').html('Image doesn\'t exist')
      $(this).remove();
    )

  )