
leaflet = new ELA.Leaflet
initMap = (id, image_url, width, height, points = null) ->
  leaflet.init id, image_url, [width,height], points

jQuery ->
  if $('#map')
    window.initMap = initMap
    initMap('map', '/assets/island-geomap.jpg', 5100, 3300, ELA.fixtures.leaflet.SamplePoints) if $("div#map").length

    if $('#sample_tile_map')[0]
      tile_map = L.map('sample_tile_map').setView [0, 0], 1

      L.tileLayer('/sample_tiles/{z}/{x}/{y}.png',
        minZoom: 1
        maxZoom: 5
        tms: true
      ).addTo tile_map