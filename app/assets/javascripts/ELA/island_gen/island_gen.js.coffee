
class ELA.Island
  layers: []
  width: null
  height: null
  constructor: (bounds) ->
    this.width = bounds[0]
    this.height = bounds[1]
    this.addLayers [50,100,500]

  addLayers: (levels) ->
    this.layers.push new Layer(this.width, this.height, l) for l in levels


class Layer
  points: []
  voronoi: null
  edges: []
  cells: []
  vertices: []
  width: null
  height: null
  level: null
  constructor: (w, h, num) ->
    this.width    = w
    this.height   = h
    this.number   = num
    this.voronoi  = new Voronoi()
    this.points   = this.seed_points()
    this.compute()

  compute: ->
    this.voronoi.Compute(this.points, this.width, this.height);
    this.edges = this.voronoi.GetEdges();
    this.cells = this.voronoi.GetCells();

  seed_points: ->
    new Point(Math.random() * this.width, Math.random() * this.height) for i in [1..this.number]


class Trace
  layer: {}
  canvas: {}
  constructor: (layer, canvas) ->
    this.layer = layer
    this.canvas = canvas

  edges : ->
    this.edge edge for edge in this.layer.edges

  points: ->
    console.log
    this.point point for point in this.layer.points

  edge : (edge) ->
    this.line edge.start, edge.end

  line : (start, end) ->
    c = this.canvas.context
    c.lineWidth = 0.5;
    c.strokeStyle = "#000";
    c.beginPath();
    c.moveTo(start.x, start.y);
    c.lineTo(end.x, end.y);
    c.closePath();
    c.stroke();

  point : (point, color, text = '') ->
    c = this.canvas.context
    size = if text then 10 else 3
    c.fillStyle = color
    c.beginPath()
    c.arc(point.x, point.y, size, 0, Math.PI*2, true)
    c.closePath()
    c.fill()
    traceText text, x, y, '#fff' if text


$ ->
  size    = [500, 500]
  igen    = new ELA.Island(size)
  canvas  = new ELA.Canvas($('#trace_voronoi_canvas'), size)
  trace   = new Trace(igen.layers[0], canvas)

  $('#trace_voronoi_next').click ->
    trace.edges()
    trace.points()
    #console.log igen.layers[0]

