# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

scheme_measure =
  x           : 5
  y           : 7
  w           : 1170
  h           : 400
  unit_space  : 20
  unit        : null
  map         : new ELA.Processing.Square(this.w, this.h)
  max_lexiles : 0

full_measure =
  x           : 5
  y           : 7
  w           : 5100
  h           : 4000
  unit_space  : 100
  unit        : null
  map         : new ELA.Processing.Square(this.w, this.h)
  max_lexiles : 0


$ ->


  ELA.Processing.TRACE.measure = scheme_measure

  # initial objects and settings
  container = $('div#canvas_container')

  canvas_scheme = new ELA.Canvas( $('canvas#island') ) if $('canvas#island')[0]
  canvas_render = new ELA.Canvas( $('canvas#c')      ) if $('canvas#c')[0]

  if $('canvas#gather')[0]
    canvas_gather = new ELA.Canvas( $('canvas#gather'), [full_measure.w, full_measure.h] )


  init = (data) ->
    ELA.SessionData = data
    current_unit  = parseInt( canvas_scheme.$.attr "unit" )
    scheme_size_session = new ELA.Processing.Session data, scheme_measure, current_unit
    scheme_size_session.zoom 2, canvas_scheme if scheme_size_session.current
    scheme_size_session.draw()

    full_size_session = new ELA.Processing.Session data, full_measure, current_unit
    ELA.DATA.session = full_size_session

    if scheme_measure.h < scheme_measure.map.height()
      scheme_measure.h = canvas_scheme.height = scheme_measure.map.height()

    $('#render_map').click (e) ->
      mapGatherer = new ELA.graph.MapGatherer(full_size_session, canvas_gather)

  if canvas_scheme
    canvas_scheme.el.width = scheme_measure.w
    canvas_scheme.el.height = scheme_measure.h
    canvas_scheme.$.draggable({cursor: 'move'})
    scheme_measure.unit = parseInt( canvas_scheme.$.attr("unit") )
    ELA.Processing.TRACE.c = canvas_scheme.el.getContext('2d')
    ELA.Processing.json.url = canvas_scheme.$.attr "src"
    ELA.Processing.json.get ( (data) -> init (data) )







