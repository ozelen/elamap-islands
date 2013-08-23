
leaflet = new ELA.Leaflet
initMap = (id, image_url, width, height, points = null) ->
  leaflet.init id, image_url, [width,height], points

ELA.initMap = initMap

jQuery ->
  if $('#map')[0]
    window.initMap = initMap
    initMap('map', '/assets/island-geomap.jpg', 5100, 3300, ELA.fixtures.leaflet.SamplePoints) if $("div#map").length

  if $('#sample_tile_map')[0]
    tile_map = L.map('sample_tile_map').setView [0, 0], 1

    L.tileLayer('http://elamapping.s3.amazonaws.com/mockups/tiled/ancient/ancient_looking_map/{z}/{x}/{y}.png',
      minZoom: 1
      maxZoom: 5
      tms: true
    ).addTo tile_map


  if $('#mockup_tile_map')[0]

    tm = L.map('mockup_tile_map').setView [0, 0], 2

    L.tileLayer('http://elamapping.s3.amazonaws.com/mockups/tiled/ancient/ancient_looking_map/{z}/{x}/{y}.png',
                minZoom: 1
                maxZoom: 5
                tms: true
    ).addTo tm

#    top_left      = tm.unproject(new L.Point(0, 0))
#    bottom_right  = tm.unproject(new L.Point(6776, 4926))
#    imageBounds = [[top_left.lat, top_left.lng],[bottom_right.lat, bottom_right.lng]]
#    console.log imageBounds
#
#    tm
#      .setMaxBounds(imageBounds)
#      .fitBounds(imageBounds)
