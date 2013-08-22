
LeafletMap = (element, url, width, height) ->
  map = ELA.initMap(element, url, width, height, ELA.DATA.labels)
  points = []
  for unit in ELA.DATA.session.units
    for text in unit.texts
      points.push
        name: text.data.name
        author: text.data.author
        val: text.data.lexiles
        color: 'red'
        latlng: map.unproject [text.x+200, text.y+200]
  map.path points


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
      LeafletMap 'scheme-map', url, this.width, this.height

    .error ->
      $('session-map').html('Image not found')
      $(this).remove();

  fullScreenMap = $('#fullscreen-map')

  if fullScreenMap[0]
    url = fullScreenMap.attr('url')
    $('<img src="' + url + '">')
      .load  ->
        LeafletMap 'fullscreen-map', url, this.width, this.height
      .error ->
        $('fullscreen-map').html('Image not found')
        $(this).remove();