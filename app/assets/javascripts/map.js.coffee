
leaflet = new ELA.Leaflet
initMap = (id, image_url, width, height, points = null, zoom=null) ->
  leaflet.init id, image_url, [width,height], points, zoom

ELA.initMap = initMap

jQuery ->
  if $('#map')[0]
    window.initMap = initMap
    if $("div#map").length
      points = ELA.fixtures.leaflet.SamplePoints unless $('#map').attr('overlay-markers') == 'no'
      initMap('map', $('#map').attr('overlay-image'), $('#map').attr('overlay-width'), $('#map').attr('overlay-height'), points)

  if $('#sample_tile_map')[0]
    tile_map = L.map('sample_tile_map').setView [0, 0], 1

    L.tileLayer('http://elamapping.s3.amazonaws.com/mockups/tiled/voronoi/2/{z}/{x}/{y}.png',
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
