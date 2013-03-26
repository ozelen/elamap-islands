# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  #  [40.712, -74.227]
  #  lat = 40.712216
  #  lng = -74.22655
  #  imageBounds = [[lat, lng], [40.773941, -74.12544]];

  width = 5100
  height = 3300

  map = L.map('map', {maxZoom:13, crs: L.CRS.Simple}).setView([0,0], 13)

  s1 = map.unproject(new L.Point(0, 0))
  s2 = map.unproject(new L.Point(width, height))

  imageUrl = '/assets/island-geomap.jpg'
  imageBounds = [[s1.lat, s1.lng],[s2.lat, s2.lng]]
  map
    .setMaxBounds(imageBounds)
    .fitBounds(imageBounds)

  popup = L.popup();

  onMapClick = (e) ->
    #point = L.CRS.latLngToPoint( e.latlng, e.zoom )

    popup
      .setLatLng(e.latlng)
      .setContent("You clicked the map at " + e.latlng.toString() )
      .openOn(map)


  map.on 'click', onMapClick


#  L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
#    attribution: '' # 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
#    maxZoom: 18
#  }).addTo(map);

  L.imageOverlay(imageUrl, imageBounds).addTo(map);