# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

measure =
  x           : 5
  y           : 8
  w           : 1170
  h           : 400
  unit_space  : 20
  unit        : null

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

  unit : (unit, x=0) ->
    x_left = x
    prev_r = 0
    y_top  = measure.h
    y_bot  = 0

    if measure.unit
      color = if unit.id == measure.unit then '#095' else '#ccc'
    else
      color = this.rnd_color()

    push = (text) ->
      r = text.lessons * measure.x / 2
      y = text.genre * measure.h / measure.y
      y_bot  = y + r if y_bot < y + r
      y_top  = y - r if y_top > y - r
      x += r + prev_r
      prev_r = r
      draw.circle(x, y, r, color)
      draw.lexiles(x, y, text.lexiles)

    push text for text in unit.texts
    x_right = x+prev_r
    x_mid = x_left + (x_right - x_left) / 2
    draw.label(unit.name, x_mid, y_bot + 10)
    #draw.frame(x_left, y_top, x_right, y_bot)
    unit.x = x_left
    unit.y = y_top
    unit.w = x_right - unit.x
    unit.h = y_bot - unit.y
    x_right # return end point of island

  session : (session) ->
    whitespace = measure.unit_space
    whitespaces = (session.units.length - 1) * whitespace
    x = -whitespace # start x point in pixels
    measure.x = (measure.w - whitespaces ) / session.lessons
    x = this.unit unit, x+whitespace for unit in session.units

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

class Unit
  texts = []
  constructor: (unit) ->


class Session
  units   = []
  data    = null
  $canvas = null
  canvas  = null
  container = null
  current: null
  constructor: (session, canv, selected_unit_id = null) ->
    units = session.units
    data = session
    this.session = session
    $canvas = canv
    canvas = canv[0]
    container = $('div#canvas_container')

    this.current = this.find(selected_unit_id) if selected_unit_id

  find: (id) ->
    result = null
    (result = unit if unit.id == id) for unit in units
    result

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
    draw.session data
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
    draw.session data

  if canvas
    canvas.width = measure.w
    canvas.height = measure.h
    $canvas.draggable({cursor: 'move'})
    measure.unit = parseInt( $canvas.attr("unit") )
    draw.c = canvas.getContext('2d')
    json.url = $canvas.attr "src"
    json.get ( (data) -> init (data) )



