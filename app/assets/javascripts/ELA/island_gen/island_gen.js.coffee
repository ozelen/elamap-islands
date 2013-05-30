
class ELA.Island
  width: null
  height: null
  peaks: []
  constructor: (bounds, layers) ->
    this.SPREADS = []
    this.layers = []
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
    this.improve_points() if this.number >= 200
    this.noisy_edges = new ELA.graph.NoisyEdges()

  # Lloyd Relaxation: move each point to the centroid of the
  # generated Voronoi polygon, then generate Voronoi again
  improve_points : () ->
    layer = this

    for i in [1..3]
      layer.points[j] = layer.cells[j].centroid for cell, j in layer.cells
      layer.compute()

  compute: ->
    this.voronoi.Compute(this.points, this.width, this.height);
    this.edges = this.voronoi.GetEdges();
    this.cells = this.voronoi.GetCells();

  seed_points: ->
    new Point(Math.random() * this.width, Math.random() * this.height) for i in [1..this.number]

  select_cells : (spread) ->
    layer = this
    selected_cells = []

    not_overflow = (cell) ->
      layer.width-50 >= cell.centroid.x >= 50 || layer.height-50 >= cell.centroid.y >= 50

    for point in spread.points
      for cell in layer.cells
        if cell.centroid.distanceTo(point) <= spread.radius and not_overflow cell
          selected_cells.push cell
          cell.surface = 'land' # define selected cells as land

    # modifying voronoi diagram data
    # adding related edges and points into cells
    for edge in this.edges
      for cell, i in this.cells
        if cell.surface # do it only for cells with defined surface, not to lose extra performance on unused cells
          cell.point = this.points[i] # cell -> point relation
          if this.points[i] == edge.left or this.points[i] == edge.right
            unique = true
            for existent in cell.edges
              if existent == edge
                unique = false
                break

            if unique
              cell.edges.push edge
              edge.path = this.noisy_edges.build edge

    for cell in this.cells
      if cell.surface
        cell.path = this.sew_cell cell

    selected_cells

  get_selected_vertices : (cells) ->
    res = []
    res = res.concat cell.vertices for cell in cells
    res

  sew_cell : (cell) ->
    cell.path = []

    reverse = (arr) ->
      arr.slice(0).reverse()

    sew = (edges, path = []) ->
      for edge, i in edges
        if path.length == 0
          a = edges.shift()
          #console.log 'first', a
          return sew(edges, edge.path)
        else
          new_path = null
          if path[path.length-1] == edge.start
            new_path = path.concat edge.path
          else if path[path.length-1] == edge.end
            new_path = path.concat reverse(edge.path)
          else if path[0] == edge.end
            new_path = edge.path.concat path
          else if path[0] == edge.start
            #console.log path == path.reverse()
            new_path = reverse(edge.path).concat path
          if new_path
            a = edges.splice(i, 1)
            #console.log 'add', a
            return sew edges, new_path
      #console.log 'done', path, edges
      path

    sew(cell.edges.slice(0))

class Trace
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

  cell_shred : (cell, fill, stroke) ->
    c = this.canvas.context
    c.fillStyle = fill
    c.strokeStyle = stroke
    c.lineWidth = 2;
    c.beginPath()
    c.moveTo(cell.path[0].x, cell.path[0].y);
    c.lineTo(point.x, point.y) for point in cell.path
    c.closePath()
    fill = red if !fill and !stroke
    c.fill() if fill
    c.stroke() if stroke
    this

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

$ ->

  init = (session) ->
    elaSession = session
    elaUnit = elaSession.current

    size    = [elaUnit.w+300, elaUnit.h+300]
    igen    = new ELA.Island(size, [100,200,1000])
    ELA.DATA.VoronoiStack = igen

    #console.log igen.layers[0].points[0]

    igen.SPREADS = []
    canvas  = new ELA.Canvas($('#trace_voronoi_canvas'), size)

    layer1  = igen.layers[0]
    layer2  = igen.layers[1]
    last_layer  = igen.layers[igen.layers.length-1]

    trace1   = new Trace(layer1, canvas)
    trace2   = new Trace(layer2, canvas)
    trace    = new Trace(last_layer, canvas)
    ELA.trace = trace

    all_cells = []


    cond_spreads = []
    add_area = (text) ->
      spread = new Spread [new Point text.x - elaUnit.x + 150, text.y - elaUnit.y + 150], text.r
      cond_spreads.push spread
      isl = igen.make spread
      iss = last_layer.select_cells spread
      last_layer.select_cells(s)  for s in igen.SPREADS

    add_area text for text in elaUnit.texts

    for cell, i in igen.layers[2].cells
      if cell.surface == 'land'
        trace.cell_shred cell, '#333', '#333'
        #trace.point cell.point, 'red', i
#        for edge in cell.edges
#          #trace.edge edge
#          canvas.stroke(0.5, 'black').vector edge.path

    $('#trace_shred').click ->
      trace.shred null, '#ccc'

    $('#trace_cells').click ->
      trace.edges()
      trace1.edges()

    $('#trace_scheme').click ->
      trace.spreads cond_spreads

    $('#trace_spread').click ->
      trace.spreads igen.SPREADS


    #trace2.edges()
    #trace.points()
    #trace.cell(igen.layers[0].cells[10])
    #steps[i++]() if steps[i]

  ELA.DATA.json.onLoad ->

    $('#trace_voronoi_next').click ->
      init(ELA.DATA.session)
      $('#trace_voronoi_controls').show()



