
class ELA.Island
  layers: []
  width: null
  height: null
  peaks: []
  constructor: (bounds) ->
    this.width = bounds[0]
    this.height = bounds[1]
    this.addLayers [50,100,500]

  addLayers: (levels) ->
    this.layers.push new Layer(this.width, this.height, l) for l in levels

  select_cells : (layer = null, size = 100) ->
    if layer
      layer.select_cells points, size
      points = layer.get_selected_vertices()
    else
      points = this.peaks
    this.select_cells points, size/3


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

  compute: ->
    this.voronoi.Compute(this.points, this.width, this.height);
    this.edges = this.voronoi.GetEdges();
    this.cells = this.voronoi.GetCells();

  seed_points: ->
    new Point(Math.random() * this.width, Math.random() * this.height) for i in [1..this.number]

  select_cells : (points, size) ->
    layer = this
    distance_to = ->

    select_by_point = (point) ->
      (layer.selected.push cell if cell.centroid.distanceTo(point) <= size) for cell in layer.cells

    select_by_point point for point in points

  get_selected_vertices : () ->
    res = []
    res = res.concat cell.vertices for cell in this.selected
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

$ ->
  size    = [500, 500]
  igen    = new ELA.Island(size)
  canvas  = new ELA.Canvas($('#trace_voronoi_canvas'), size)
  layer1  = igen.layers[0]
  layer2  = igen.layers[1]
  trace   = new Trace(layer1, canvas)
  layer1.select_cells [new Point(250, 250)], 100
  sel = layer1.selected
  sel_vertices = layer1.get_selected_vertices()
  layer2.select_cells sel_vertices, 50
  l2_selected_cells = layer2.selected

  steps = [
    -> trace.edges()
    -> trace.cells sel
    -> trace.points sel_vertices
    ->
      trace.set_layer(layer2).edges().cells(l2_selected_cells)
  ]

  i=0
  $('#trace_voronoi_next').click ->
    console.log ELA.DATA.session
    steps[i++]() if steps[i]

    #trace.points()
    #trace.cell(igen.layers[0].cells[10])
    #console.log igen.layers[0]

