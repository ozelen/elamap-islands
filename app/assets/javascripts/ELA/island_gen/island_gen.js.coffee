
class ELA.Island
  layers: []
  width: null
  height: null
  peaks: []
  SPREADS : []
  constructor: (bounds, layers) ->
    this.width = bounds[0]
    this.height = bounds[1]
    this.addLayers layers

  addLayers: (levels) ->
    this.add_layer new Layer(this.width, this.height, l) for l in levels

  add_layer: (layer) ->
    this.layers.push layer
    layer.prev = this.layers[this.layers.length-2]

  make : (spread, layer_id = 0) ->
    this.SPREADS.push spread
    layer = this.layers[layer_id]
    cells = layer.select_cells spread
    new_spread = new Spread(layer.get_selected_vertices(cells), spread.radius / (this.layers.length * 1.4))
    #console.log 'Spread: - ', new_spread, spread.radius, this.layers.length, spread.radius / this.layers.length
    if this.layers[layer_id+1]
      this.make new_spread, layer_id+1
    else cells

class Spread
  points : []
  radius : null
  constructor : (points, radius) ->
    this.points = points
    this.radius = radius

class Layer
  points: []
  voronoi: null
  edges: []
  cells: []
  vertices: []
  selected: [] # selected cells
  width: null
  height: null
  level: null
  constructor: (w, h, num) ->
    this.width    = w
    this.height   = h
    this.number   = num
    this.voronoi  = new Voronoi()
    this.points   = this.seed_points()
    this.edges = []
    this.cells = []
    this.selected = []
    this.compute()
    this.improve_points()

  # Lloyd Relaxation: move each point to the centroid of the
  # generated Voronoi polygon, then generate Voronoi again
  improve_points : () ->
    layer = this

    improve = () ->
      layer.compute()
      layer.points[i] = layer.cells[i].centroid for cell, i in layer.cells

    improve() for i in [1..3]

  compute: ->
    this.voronoi.Compute(this.points, this.width, this.height);
    this.edges = this.voronoi.GetEdges();
    this.cells = this.voronoi.GetCells();

  seed_points: ->
    new Point(Math.random() * this.width, Math.random() * this.height) for i in [1..this.number]

  select_cells : (spread) ->
    console.log spread
    layer = this
    selected_cells = []

    select_by_point = (point) ->
      for cell in layer.cells
        selected_cells.push cell if cell.centroid.distanceTo(point) <= spread.radius

    select_by_point point for point in spread.points

    selected_cells

  get_selected_vertices : (cells) ->
    res = []
    res = res.concat cell.vertices for cell in cells
    res



class Trace
  layer: {}
  canvas: {}
  constructor: (layer, canvas) ->
    this.layer = layer
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

  cells : (cells) ->
    this.cell cell for cell in cells
    this

  cell : (cell, color = 'red') ->
    c = this.canvas.context
    c.fillStyle = color
    c.beginPath()
    c.lineTo(vertex.x, vertex.y) for vertex in cell.vertices
    c.closePath()
    c.fill()
    this

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

$ ->
  size    = [500, 500]
  igen    = new ELA.Island(size, [50,20,1000])
  canvas  = new ELA.Canvas($('#trace_voronoi_canvas'), size)

  layer1  = igen.layers[0]
  layer2  = igen.layers[1]
  last_layer  = igen.layers[igen.layers.length-1]

  trace1   = new Trace(layer1, canvas)
  trace2   = new Trace(layer2, canvas)
  trace    = new Trace(last_layer, canvas)

  all_cells = []
#  layer1.select_cells [new Point(250, 250)], 100
#  sel = layer1.selected
#  sel_vertices = layer1.get_selected_vertices()
#  layer2.select_cells sel_vertices, 50
#  l2_selected_cells = layer2.selected

  steps = [
    -> trace.edges()
    -> trace.cells sel
    -> trace.points sel_vertices
    ->
      trace.set_layer(last_layer).edges().cells(l2_selected_cells)
  ]

  i=0
  $('#trace_voronoi_next').click ->
    spread = new Spread [new Point 250, 250], 100
    #console.log ELA.DATA.session
    #steps[i++]() if steps[i]
    isl = igen.make spread
    iss = last_layer.select_cells spread
#    trace.cells isl
#    trace.cells iss

    trace.cells last_layer.select_cells(s)  for s in igen.SPREADS

    trace.spread spread
    trace.edges()
    trace1.edges()
    #trace2.edges()
    #trace.points()
    #trace.cell(igen.layers[0].cells[10])
    #console.log igen.layers[0]

