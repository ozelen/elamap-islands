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