class ELA.MapGen.Trace
  constructor: (gen, layer, canvas) ->
    this.layer = layer
    this.gen = gen
    this.canvas = canvas

  set_layer : (layer) ->
    this.layer = layer
    this

  edges : ->
    this.edge edge for edge in this.layer.edges
    this

  points: (points = this.layer.points) ->
    this.point(point, 'red', i) for point, i in points
    this

  edge : (edge) ->
    this.line edge.start, edge.end
    this

  line : (start, end) ->
    c = this.canvas.context
    c.lineWidth = 0.1;
    c.strokeStyle = "#000";
    c.beginPath();
    c.moveTo(start.x, start.y);
    c.lineTo(end.x, end.y);
    c.closePath();
    c.stroke();
    this

  point : (point, color, text = '') ->
    c = this.canvas.context
    size = if text then 10 else 3
    c.fillStyle = color
    c.beginPath()
    c.arc(point.x, point.y, size, 0, Math.PI*2, true)
    c.closePath()
    c.fill()
    this.text text, point.x, point.y, '#fff' if text
    this

  peaks : ->
    for cell in this.layer.cells
      #console.log cell.point.z if cell.point
      this.text cell.point.z+'', cell.point.x, cell.point.y, '#000' if cell.point
  #this.text v.z+'', v.x, v.y, '#000' for v in cell.vertices

  cells : (cells) ->
    this.cell cell for cell in cells
    this

  cell_style : (altitude) ->
    hypso = ELA.DATA.session.data.hypsometry
    # ELA.DATA.session.measure.max_lexiles
    max_lexile = 1100
    m = max_lexile/hypso.length
    p = Math.round altitude/m
    p = if p < hypso.length then p else hypso.length - 1
    h = hypso[p]
    res =
      name        : h.name
      lineWidth   : 4
      strokeStyle : '#' + h.color
      fillStyle   : '#' + h.color

  cell : (cell, color = 'red') ->
    c = this.canvas.context
    c.fillStyle = color
    c.beginPath()
    c.lineTo(vertex.x, vertex.y) for vertex in cell.vertices
    c.closePath()
    c.fill()
    this

  coastline : () ->


    for cell in this.layer.cells
      this.cell_shred cell, '#f0cd9f', '#f0cd9f' if cell.surface == 'beach'

    # stroke coastline
    this.path path, null, 'black' for path in this.gen.coastline

  cell_shred : (cell, fill, stroke) ->
    this.path cell.path, fill, stroke
    this

  path : (path, fill, stroke) ->
    c = this.canvas.context
    c.fillStyle = fill
    c.strokeStyle = stroke
    c.lineWidth = 2;
    c.beginPath()
    c.moveTo(path[0].x, path[0].y);
    c.lineTo(point.x, point.y) for point in path
    c.closePath()
    fill = 'red' if !fill and !stroke
    c.fill() if fill
    c.stroke() if stroke

  draw : (fill, stroke) ->
    for cell, i in this.layer.cells
      if cell.surface
        style = this.cell_style cell.point.z
        this.cell_shred cell, style.fillStyle, style.fillStyle

  shred : (fill, stroke) ->
    for cell, i in this.layer.cells
      if cell.surface == 'land'
        this.cell_shred(cell, fill, stroke)

  tc: (i) ->
    this.cell(this.layer.cells[i], 'black')
    this.point(this.layer.points[i], 'red', i+'')

  text : (text, x, y, color) ->
    c = this.canvas.context
    c.textBaseline="middle"
    c.textAlign="center"
    c.fillStyle = color || "#000"
    c.fillText(text, x, y)
    this

  spread : (spread) ->
    c = this.canvas.context
    spread_point = (p) ->
      c.lineWidth = 0.5;
      c.strokeStyle = "#000";
      c.beginPath()
      c.arc(p.x, p.y, spread.radius, 0, Math.PI*2, true)
      c.closePath()
      c.stroke()

    spread_point point for point in spread.points

    this

  spreads : (spreads) ->
    this.spread spread for spread in spreads