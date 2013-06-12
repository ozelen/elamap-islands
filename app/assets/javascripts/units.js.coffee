# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

ELA.fixtures.scheme_colors = [
  '#1560BD', '#89CFF0', '#40E0D0', '#DE3163', '#702963', '#29AB87', '#8C92AC', '#6699CC', '#FACA16', '#CD5700'
  '#DF73FF', '#1E90FF', '#7DF9FF', '#003153', '#C9A0DC', '#00FF7F', '#228B22', '#3EB489', '#E4D00A', '#8A3324'
]

class ELA.Processing.Point
  x: 0
  y: 0
  constructor: (x, y) ->
    this.set(x, y)

  set: (x, y) ->
    this.x = x
    this.y = y

class ELA.Processing.Square
  sq = this
  vertices:
    top:
      left   : new ELA.Processing.Point(0,0)
      right  : new ELA.Processing.Point(0,0)
    bottom   :
      left   : new ELA.Processing.Point(0,0)
      right  : new ELA.Processing.Point(0,0)

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

    e.bottom(h)
    e.right(w)

  height    : -> this.dist(this.edges.top(), this.edges.bottom())
  dist      : (a, b) -> -a + b # find difference (distance) between values on axis
  set       : (x_left, y_top, x_right, y_bottom) ->
    v = this.vertices
    v.top.left.x     = v.bottom.left.x  = x_left
    v.top.left.y     = v.top.right.y    = y_top
    v.top.right.x    = v.bottom.right.x = x_right
    v.bottom.left.y  = v.bottom.right.y = y_bottom


ELA.Processing.TRACE =
  c       : null  # canvas context - must be defined before using object
  measure : null
  # trace circle (x, y, radius, inner text)
  circle : (x, y, r, color) ->
    text = text || ''
    c = this.c
    c.fillStyle = color
    c.lineWidth = 2
    c.strokeStyle = "#000"
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

  log : (msg) ->
    log = $('textarea#log')
    d = new Date()
    time = d.getHours() + ':' + ':' + d.getMinutes() + ':' + d.getSeconds()
    log.val(log.val() + '[' + time + '] ' + msg)
    console.log msg

ELA.Processing.json =
  url : null
  data : null
  callbacks : []
  get : (cb) ->
    self = this
    jQuery.ajax this.url,
              type="post",
              dataType: 'json'
    .fail (jqXHR, textStatus, errorThrown) ->
      alert "AJAX Error: #{textStatus}"
    .done (data, textStatus, jqXHR) ->
      ELA.Processing.json.data = data
      cb(data)
      callback(data) for callback in self.callbacks
    ELA.Processing.json.data

  onLoad : (func) ->
    this.callbacks.push func
    func() if this.data

ELA.DATA.json = ELA.Processing.json

class ELA.Processing.Text
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
    ELA.Processing.TRACE.circle(this.x, this.y, this.r, this.color)
    ELA.Processing.TRACE.lexiles(this.x, this.y, this.data.lexiles)

  set : (x,y,r,color) ->
    this.x = this.data.x = x
    this.y = this.data.y = y
    this.r = this.data.r = r
    this.color = color
    this.measure.max_lexiles = this.data.lexiles if this.data.lexiles > this.measure.max_lexiles


class ELA.Processing.Unit
  texts   : []
  data    : []
  measure : {}
  id      : 0
  frame   : null
  constructor: (unit, measure) ->
    this.data = unit
    this.id = unit.id
    this.measure = measure
    texts = []
    texts.push(new ELA.Processing.Text(text, this.measure)) for text in unit.texts
    this.texts = texts
    this.frame = new ELA.Processing.Square(0,0)

  set: (x) ->
    this.x_left  = x
    this.y_top   = this.measure.h
    this.y_bot   = 0
    this.y_right = 0
    prev_r = 0
    measure = this.measure
    un = this

    if measure.unit
      color = if this.data.id == measure.unit then '#095' else '#ccc'
    else
      color = ELA.fixtures.scheme_colors.shift() || ELA.Processing.TRACE.rnd_color()

    push = (text) ->
      r = text.data.lessons * measure.x / 2
      y = measure.h - text.data.genre * measure.h / measure.y
      un.y_bot  = y + r if un.y_bot < y + r
      un.y_top  = y - r if un.y_top > y - r
      x += r + prev_r
      prev_r = r

      text.set x, y, r, color

    push text for text in this.texts

    this.x_right = x+prev_r
    x_mid = this.x_left + (this.x_right - this.x_left) / 2
    ELA.Processing.TRACE.label(this.data.name, x_mid, this.y_bot + 10)
    # TRACE.frame(x_left, y_top, x_right, y_bot)
    this.data.x = this.x_left
    this.data.y = this.y_top
    this.data.w = this.x_right - this.data.x
    this.data.h = this.y_bot - this.data.y
    edge = measure.map.edges
    edge.bottom(this.y_bot)  if this.y_bot   > edge.bottom()
    edge.right(this.x_right) if this.x_right > edge.right()
    edge.left(this.x_left)   if this.x_left  < edge.left()
    edge.top(this.y_top)     if this.y_top   < edge.top()
    this.frame.set this.x_left, this.y_top, this.x_right, this.y_bot
    this.x_right # return end point of island

  draw: ->
    text.draw() for text in this.texts


class ELA.Processing.Session
  units   : null
  measure : {}
  data    : {}
  id      : null
  container = null
  current: null
  selected_unit: null
  selected_unit_id : null

  constructor: (session, measure, selected_unit_id = null) ->
    this.id = session.id
    this.data = session
    this.session = session
    this.measure = measure
    this.units = []
    container = $('div#canvas_container')
    this.create_unit(unit) for unit in this.data.units
    this.current = this.find(selected_unit_id) if selected_unit_id
    this.set_units()

  create_unit : (unit_data) ->
    unit = new ELA.Processing.Unit(unit_data, this.measure)
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
    ELA.Processing.TRACE.scale()
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
    ELA.Processing.TRACE.clear()
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

class ELA.Processing.Canvas
  $       : null # jQuery object
  el      : null # canvas html element
  s3      :
    url   : null
    bucket: null
    fname : null
  context : null
  constructor: (canvas) ->
    this.$  = canvas
    this.el = canvas[0]
    this.context = canvas[0].getContext('2d')
    this.s3.url = canvas.attr 's3url'
    this.s3.bucket = canvas.attr 's3bucket'
    this.s3.fname = canvas.attr 's3fname'

  img : (image, x, y) ->
    console.log 'Place image on canvas: ', image, x, y
    this.context.drawImage(image, x, y)

  store: ( callback = -> ) ->
    console.log 'Store map'
    canvas_data = this.el.toDataURL "image/png"
    base64 = canvas_data.replace /^data:image\/(png|jpg);base64,/, ""
    s3 = this.s3
    $.post s3.url, {dir: s3.bucket, fname: s3.fname, data:base64}, callback

  clear: ->
    this.el.width = this.el.width






$ ->

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

  ELA.Processing.TRACE.measure = scheme_measure

  # initial objects and settings
  container = $('div#canvas_container')

  canvas_scheme = new ELA.Processing.Canvas( $('canvas#island') ) if $('canvas#island')[0]
  canvas_render = new ELA.Processing.Canvas( $('canvas#c') )      if $('canvas#c')[0]

  if $('canvas#gather')[0]
    canvas_gather = new ELA.Processing.Canvas( $('canvas#gather') )
    canvas_gather.el.width = full_measure.w
    canvas_gather.el.height = full_measure.h



  btn_unit = $('button#draw_unit')
  btn_upload = $ '#upload_session_scheme'

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
      #TRACE.session data



    btn_upload.click ->
      $('#map_tab').addClass('hidden')
      scheme_size_session.upload(btn_upload.attr 'href')

    $('#render_map').click (e) ->
      mapGatherer = new ELA.graph.MapGatherer(full_size_session, canvas_gather)

    $('#render_island').click (e) ->
      factory = new IslandFactory "c",
        cells       : 1000,
        naturalize  : 10,
        width       : full_size_session.current.w + 200,
        height      : full_size_session.current.h + 200,
        max_lexile  : full_measure.max_lexiles,
        hypsometry  : data.hypsometry

      unit = full_size_session.current
      island = (text) ->
        factory.add(
          x: text.x - unit.x + 100,
          y: text.y - unit.y + 100,
          r: text.r + 25,
          lexile: text.lexiles
        )

      island text for text in unit.texts
      canvas_render.store()


  if canvas_scheme
    canvas_scheme.el.width = scheme_measure.w
    canvas_scheme.el.height = scheme_measure.h
    canvas_scheme.$.draggable({cursor: 'move'})
    scheme_measure.unit = parseInt( canvas_scheme.$.attr("unit") )
    ELA.Processing.TRACE.c = canvas_scheme.el.getContext('2d')
    ELA.Processing.json.url = canvas_scheme.$.attr "src"
    ELA.Processing.json.get ( (data) -> init (data) )







