# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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

measure =
  x           : 5
  y           : 7
  w           : 1170
  h           : 400
  unit_space  : 20
  unit        : null
  map         : new Square(this.w, this.h)

draw =
  c : null  # canvas context - shouf be defined before using object

  # trace circle (x, y, radius, inner text)
  circle : (x, y, r, color) ->
    text = text || ''
    c = this.c
    c.fillStyle = color
    c.beginPath()
    c.arc(x, y, r, 0, Math.PI*2, true)
    c.closePath()
    c.fill()
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
    line = (num) ->
      y = Math.round( num * measure.h / measure.y )
      c.strokeStyle = "#ccc"
      c.outlineWidth = 1
      c.beginPath()
      c.moveTo(0,y)
      c.lineTo(measure.w, y)
      c.closePath()
      c.stroke()
    line num for num in [1..measure.h]

  unit : (unit, x=0) ->
    nil


  clear : ->
    this.c.clearRect( 0, 0, measure.w, measure.h )

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
  data = {}
  constructor: (text) ->
    data = text




class Unit
  texts = []
  data: []
  id: 0
  constructor: (unit, id) ->
    this.id = id
    this.data = unit
    data = unit
    texts.push(new Text) for text in data.texts

  draw: (x) ->
    x_left = x
    prev_r = 0
    y_top  = measure.h
    y_bot  = 0

    if measure.unit
      color = if unit.id == measure.unit then '#095' else '#ccc'
    else
      color = draw.rnd_color()

    push = (text) ->
      r = text.lessons * measure.x / 2
      y = measure.h - text.genre * measure.h / measure.y
      y_bot  = y + r if y_bot < y + r
      y_top  = y - r if y_top > y - r
      x += r + prev_r
      prev_r = r
      draw.circle(x, y, r, color)
      draw.lexiles(x, y, text.lexiles)

    push text for text in this.data.texts

    x_right = x+prev_r
    x_mid = x_left + (x_right - x_left) / 2
    draw.label(this.data.name, x_mid, y_bot + 10)
    # draw.frame(x_left, y_top, x_right, y_bot)
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


class Session
  units   = []
  data    = {}
  $canvas = null
  canvas  = null
  container = null
  current: null
  constructor: (session, canv, selected_unit_id = null) ->
    data = session
    this.session = session
    $canvas = canv
    canvas = canv[0]
    container = $('div#canvas_container')
    units.push new Unit(unit) for unit in data.units
    this.current = this.find(selected_unit_id) if selected_unit_id

  unit_data: (id) ->
    -> data.units[id]

  find: (id) ->
    result = null
    (result = unit if unit.id == id) for unit in data.units
    result

  draw: ->
    draw.scale()
    whitespace = measure.unit_space
    whitespaces = (data.units.length - 1) * whitespace
    x = -whitespace # start x point in pixels
    measure.x = (measure.w - whitespaces ) / data.lessons
    x = unit.draw x+whitespace for unit in units

  zoom: (p) ->
    m = measure
    p = 3
    m.w*=p
    m.h*=p
    m.x*=p
    m.unit_space*=p
    #m.y*=p
    canvas.width = measure.w
    canvas.height = measure.h
    draw.clear()
    this.draw()
    unit = this.current
    c_pos = $canvas.offset()
    new_left = c_pos.left - unit.x + container.width()  / 2 - unit.w / 2
    new_top  = c_pos.top  - unit.y + container.height() / 2 - unit.h / 2
    $canvas.offset({left: new_left, top: new_top } )

$ ->
  # initial objects and settings
  container = $('div#canvas_container')
  $canvas = $('canvas#island')
  canvas = $canvas[0]
  btn_unit = $('button#draw_unit')

  init = (data) ->
    session = new Session data, $canvas, parseInt( $canvas.attr("unit") )
    session.zoom 2 if session.current
    session.draw()
    if measure.h < measure.map.height()
      measure.h = canvas.height = measure.map.height()
      draw.session data
      #console.log measure.h == 400
      #measure.h = measure.map.height
      #canvas.height = 400 # measure.map.height()
      #draw.session data

  if canvas
    canvas.width = measure.w
    canvas.height = measure.h
    $canvas.draggable({cursor: 'move'})
    measure.unit = parseInt( $canvas.attr("unit") )
    draw.c = canvas.getContext('2d')
    json.url = $canvas.attr "src"
    json.get ( (data) -> init (data) )



