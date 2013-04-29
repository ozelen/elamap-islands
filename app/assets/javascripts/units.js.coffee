# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

COLORS = [
  '#1560BD', '#89CFF0', '#40E0D0', '#DE3163', '#702963', '#29AB87', '#8C92AC', '#6699CC', '#FACA16', '#CD5700'
  '#DF73FF', '#1E90FF', '#7DF9FF', '#003153', '#C9A0DC', '#00FF7F', '#228B22', '#3EB489', '#E4D00A', '#8A3324'
]

class Point
  x: 0
  y: 0
  constructor: (x, y) ->
    this.set(x, y)

  set: (x, y) ->
    this.x = x
    this.y = y

class Square
  sq = this
  vertices:
    top:
      left   : new Point(0,0)
      right  : new Point(0,0)
    bottom   :
      left   : new Point(0,0)
      right  : new Point(0,0)

  edges      :
    top      : null
    right    : null
    bottom   : null
    left     : null

  constructor: (w, h) ->
    v = this.vertices
    e = this.edges
    e.top      = (val=null) -> if val then v.top.left.y    = val; v.top.right.y    = val else v.top.right.y
    e.right    = (val=null) -> if val then v.top.right.x   = val; v.bottom.right.x = val else v.top.right.x
    e.bottom   = (val=null) -> if val then v.bottom.left.y = val; v.bottom.right.y = val else v.bottom.left.y
    e.left     = (val=null) -> if val then v.top.left.x    = val; v.bottom.left.x  = val else v.bottom.left.x

    this.edges.bottom(h)
    this.edges.right(w)

  height    : -> this.dist(this.edges.top(), this.edges.bottom())
  dist      : (a, b) -> -a + b

TRACE =
  c       : null  # canvas context - shouf be defined before using object
  measure : null
  # trace circle (x, y, radius, inner text)
  circle : (x, y, r, color) ->
    text = text || ''
    c = this.c
    c.fillStyle = color
    c.lineWidth = 2
    c.strokeStyle = "#fff"
    c.beginPath()
    c.arc(x, y, r, 0, Math.PI*2, true)
    c.closePath()
    c.fill()
    c.stroke()
    #this.text(text, x, y, '#fff') if text

  lexiles : (x, y, lexiles) ->
    x = Math.round(x)
    c = this.c
    h = lexiles / 20
    c.lineWidth = 1
    c.strokeStyle = "#000"
    c.beginPath()
    c.moveTo(x, y)
    c.lineTo(x, y-h)
    c.closePath()
    c.stroke()

  # trace text
  label : (text, x, y, color) ->
    c = this.c
    c.textBaseline = "middle"
    c.textAlign = "center"
    c.fillStyle = color || "#000"
    c.fillText(text, x, y)

  frame : (x1,y1,x2,y2) ->
    w = x2 - x1
    h = y2 - y1
    c = this.c
    c.lineWidth = 1
    c.strokeStyle = "#ccc"
    c.strokeRect(x1,y1,w,h)

  scale : ->
    c = this.c
    m = this.measure
    line = (num) ->
      y = Math.round( num * m.h / m.y )
      c.strokeStyle = "#ccc"
      c.outlineWidth = 1
      c.beginPath()
      c.moveTo(0,y)
      c.lineTo(m.w, y)
      c.closePath()
      c.stroke()
    line num for num in [1..m.h]

  clear : ->
    this.c.clearRect( 0, 0, this.measure.w, this.measure.h )

  rnd_color : ->
    letters = '0123456789ABCDEF'.split ''
    color = '#'
    color += letters[Math.round(Math.random() * 15)] for i in [0..5]
    color

json =
  url : null
  data : null
  get : (callback) ->
    jQuery.ajax this.url,
              type="post",
              dataType: 'json'
    .fail (jqXHR, textStatus, errorThrown) ->
      alert "AJAX Error: #{textStatus}"
    .done (data, textStatus, jqXHR) ->
      json.data = data
      callback(data)
    json.data


class Text
  data    : {}
  x       : null
  y       : null
  r       : null
  color   : null
  measure : {}
  constructor: (text, measure) ->
    this.data = text
    this.measure = measure

  draw : ->
    TRACE.circle(this.x, this.y, this.r, this.color)
    TRACE.lexiles(this.x, this.y, this.data.lexiles)

  set : (x,y,r,color) ->
    this.x = this.data.x = x
    this.y = this.data.y = y
    this.r = this.data.r = r
    this.color = color
    this.measure.max_lexiles = this.data.lexiles if this.data.lexiles > this.measure.max_lexiles


class Unit
  texts   : []
  data    : []
  measure : {}
  id      : 0
  constructor: (unit, measure) ->
    this.data = unit
    this.measure = measure
    texts = []
    texts.push(new Text(text, this.measure)) for text in unit.texts
    this.texts = texts

  set: (x) ->
    x_left = x
    prev_r = 0
    y_top  = this.measure.h
    y_bot  = 0
    measure = this.measure

    if measure.unit
      color = if this.data.id == measure.unit then '#095' else '#ccc'
    else
      color = COLORS.shift() || TRACE.rnd_color()

    push = (text) ->
      r = text.data.lessons * measure.x / 2
      y = measure.h - text.data.genre * measure.h / measure.y
      y_bot  = y + r if y_bot < y + r
      y_top  = y - r if y_top > y - r
      x += r + prev_r
      prev_r = r

      text.set(x,y,r,color)

    push text for text in this.texts

    x_right = x+prev_r
    x_mid = x_left + (x_right - x_left) / 2
    TRACE.label(this.data.name, x_mid, y_bot + 10)
    # TRACE.frame(x_left, y_top, x_right, y_bot)
    this.data.x = x_left
    this.data.y = y_top
    this.data.w = x_right - this.data.x
    this.data.h = y_bot - this.data.y
    edge = measure.map.edges
    edge.bottom(y_bot)  if y_bot   > edge.bottom()
    edge.right(x_right) if x_right > edge.right()
    edge.left(x_left)   if x_left  < edge.left()
    edge.top(y_top)     if y_top   < edge.top()
    x_right # return end point of island

  draw: ->
    text.draw() for text in this.texts


class Session
  units   : []
  measure : {}
  data    : {}
  container = null
  current: null
  selected_unit: null
  selected_unit_id : null

  constructor: (session, measure, selected_unit_id = null) ->
    this.data = session
    this.session = session
    this.measure = measure
    container = $('div#canvas_container')
    this.create_unit(unit) for unit in this.data.units
    this.current = this.find(selected_unit_id) if selected_unit_id
    this.set_units()

  create_unit : (unit_data) ->
    unit = new Unit(unit_data, this.measure)
    this.units.push unit
    sel_id = this.selected_unit_id
    this.selected_unit = unit if sel_id and unit_data.id == sel_id

  unit_data: (id) ->
    -> this.data.units[id]

  find: (id) ->
    result = null
    (result = unit if unit.id == id) for unit in this.data.units
    result

  set_units: ->
    whitespace = this.measure.unit_space
    whitespaces = (this.data.units.length - 1) * whitespace
    x = -whitespace # start x point in pixels
    this.measure.x = (this.measure.w - whitespaces ) / this.data.lessons
    x = unit.set x+whitespace for unit in this.units


  draw: ->
    TRACE.scale()
    unit.draw() for unit in this.units

  zoom: (p, canvas) ->
    m = this.measure
    p = 3
    m.w*=p
    m.h*=p
    m.x*=p
    m.unit_space*=p
    #m.y*=p
    canvas.el.width = m.w
    canvas.el.height = m.h
    this.set_units()
    TRACE.clear()
    this.draw()
    unit = this.current
    if unit
      c_pos = canvas.$.offset()
      new_left = c_pos.left - unit.x + container.width()  / 2 - unit.w / 2
      new_top  = c_pos.top  - unit.y + container.height() / 2 - unit.h / 2
      canvas.$.offset({left: new_left, top: new_top } )

  upload: (url, canvas) ->
    w = 5100
    h = 3300
    k = h/this.measure.h
    #window.sessionmap = {x:}
    this.zoom k, canvas
    canvas_data = canvas.el.toDataURL "image/png"
    base64 = canvas_data.replace /^data:image\/(png|jpg);base64,/, ""
    $.post url, {data:base64, dir: 'sessions'}
    false

class Canvas
  $       : null # jQuery object
  el      : null # canvas html element
  context : null
  constructor: (canvas) ->
    this.$  = canvas
    this.el = canvas[0]
    this.context = canvas[0].getContext('2d')


  store: (bucket) ->
    canvas_data = this.canvas.toDataURL "image/png"
    base64 = canvas_data.replace /^data:image\/(png|jpg);base64,/, ""
    $.post url, {dir: 'blabla', data:base64}

  clear: ->
    this.el.width = this.el.width

$ ->

  measure =
    x           : 5
    y           : 7
    w           : 1170
    h           : 400
    unit_space  : 20
    unit        : null
    map         : new Square(this.w, this.h)
    max_lexiles : 0

  TRACE.measure = measure

  # initial objects and settings
  container = $('div#canvas_container')

  canvas_scheme = new Canvas( $('canvas#island') )

  btn_unit = $('button#draw_unit')
  btn_upload = $ '#upload_session_scheme'

  init = (data) ->
    session = new Session data, measure, parseInt( canvas_scheme.$.attr("unit") )
    session.zoom 2, canvas_scheme if session.current
    session.draw()

    if measure.h < measure.map.height()
      measure.h = canvas.height = measure.map.height()
      TRACE.session data

    btn_upload.click ->
      $('#map_tab').addClass('hidden')
      session.upload(btn_upload.attr 'href')

    $('#render_island').click (e) ->
      factory = new IslandFactory "c",
        cells       : 1000,
        naturalize  : 10,
        width       : session.current.w + 200,
        height      : session.current.h + 200,
        max_lexile  : measure.max_lexiles,
        hypsometry  : data.hypsometry

      unit = session.current
      island = (text) ->
        factory.add(
          x: text.x - unit.x + 100,
          y: text.y - unit.y + 100,
          r: text.r + 25,
          lexile: text.lexiles
        )

      island text for text in unit.texts


  if canvas_scheme
    canvas_scheme.el.width = measure.w
    canvas_scheme.el.height = measure.h
    canvas_scheme.$.draggable({cursor: 'move'})
    measure.unit = parseInt( canvas_scheme.$.attr("unit") )
    TRACE.c = canvas_scheme.el.getContext('2d')
    json.url = canvas_scheme.$.attr "src"
    json.get ( (data) -> init (data) )





