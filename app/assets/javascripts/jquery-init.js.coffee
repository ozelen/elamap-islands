$ ->
  $('.nav-tabs a').click( (e) ->
    e.preventDefault()
    $(this).tab('show')
  )
  $('.nav-tabs a:first').tab('show')

  map_image = $('.nav-tabs #map_tab a').attr('url')

  if map_image
    $('<img src="' + map_image + '">')
    .load ->
      $('#map_tab').show()
    .error ->
      false


  $('.nav-tabs #map_tab a').click (e) ->
    e.preventDefault()
    url = $(this).attr('url')

    $('<img src="' + url + '">')
    .load  ->
      initMap('scheme-map', url, this.width, this.height)
    .error ->
      $('session-map').html('Image not found')
      $(this).remove();


  fullScreenMap = $('#fullscreen-map')

  if fullScreenMap[0]
    alert 'full'
    url = fullScreenMap.attr('url')
    alert 'url'
    $('<img src="' + url + '">')
      .load  ->
        alert 'load'
        initMap('fullscreen-map', url, this.width, this.height)
      .error ->
        alert 'error loading'
        $('fullscreen-map').html('Image not found')
        $(this).remove();