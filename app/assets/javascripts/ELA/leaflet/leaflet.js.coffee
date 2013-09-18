# Adapter for Leaflet plugin
class ELA.Leaflet
  el    : null
  size  : [0,0]
  map   : {}
  icons : null
  constructor: ->
    this.icons = ELA.fixtures.leaflet.icons

  unproject : (coords) ->
    this.map.unproject(new L.Point(coords[0], coords[1]))

  marker : (coords, msg = 'marker') ->
    latlng = this.unproject coords
    L.marker(latlng, icon: new L.icon(this.icons['red'])).addTo(this.map).bindPopup(msg)
    this

  init: (el_id, image_url, size, points = null) ->
    this.size = size
    this.el = $('#' + el_id)
    timestamp = new Date().getTime()
    divid = 'map' + timestamp
    this.el.html('<div id="' + divid + '" class="session-map"></div>')
    this.map = new L.Map(divid, {maxZoom:13, crs: L.CRS.Simple}).setView([0,0], 13)

    top_left      = this.map.unproject(new L.Point(0, 0))
    bottom_right  = this.map.unproject(new L.Point(this.size[0], this.size[1]))
    imageUrl = image_url
    imageBounds = [[top_left.lat, top_left.lng],[bottom_right.lat, bottom_right.lng]]

    this.map
      .setMaxBounds(imageBounds)
      .fitBounds(imageBounds)

    L.imageOverlay(imageUrl, imageBounds).addTo(this.map);

    if points
      this.path points

    this

  path : (points) ->
    markerPopupMessage = (marker) -> "<b>" + marker.name + "</b><br><i>" + marker.author + "</i> <br>[" +marker.val+ "]"
    markers = []
    ths = this
    create_marker = (point, index) ->
      marker = L.marker( point.latlng, icon: new L.icon(ths.icons[point.color]) )
      marker
        .bindPopup(markerPopupMessage point)
        .addTo(ths.map)
        .bindLabel(point.name, {noHide: true, direction: 'auto', className: "map_label_#{index}"}).showLabel()

      #marker.on 'click',   -> marker.fire 'popupopen'
      marker.on 'popupopen',   -> $(".map_label_" + index).hide()
      marker.on 'popupclose',  -> $(".map_label_" + index).show()

      marker

    create_marker point, index for point, index in points


    for marker, i in points
      L.polyline([marker.latlng, points[i+1].latlng], {color: '#000', opacity: 0.3}).addTo(this.map) if points[i+1]