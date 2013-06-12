
leaflet = new ELA.Leaflet
initMap = (id, image_url, width, height, points = null) ->
  leaflet.init id, image_url, [width,height], points

jQuery ->
  if $('#map')
    window.initMap = initMap
    initMap('map', '/assets/island-geomap.jpg', 5100, 3300, ELA.fixtures.leaflet.SamplePoints) if $("div#map").length
