
class ELA.Island
  width: null
  height: null
  peaks: []
  coastline: []
  constructor: (bounds, layers) ->
    this.coastline = []
    this.SPREADS = []
    this.layers = []
    this.width = bounds[0]
    this.height = bounds[1]
    this.addLayers layers

    this.junction_points = []

  addLayers: (levels) ->
    this.add_layer new Layer(this.width, this.height, l), i for l, i in levels

  add_layer: (layer, id) ->
    this.layers.push layer
    layer.prev = this.layers[this.layers.length-2]
    layer.id = id

  create : (unit) ->
    igen = this
    last_layer = this.layers[this.layers.length-1]

    make_area = (spread, layer_id = 0) ->
      igen.SPREADS.push spread
      layer = igen.layers[layer_id]
      cells = layer.select_cells spread
      new_spread = new Spread(layer.get_selected_vertices(cells), spread.radius / (igen.layers.length * 1))
      if igen.layers[layer_id+1]
        make_area new_spread, layer_id+1
      else
        cells

    add_area = (spread) ->
      isl = make_area spread
      iss = last_layer.select_cells spread
      last_layer.select_cells(s) for s in igen.SPREADS

    process = ->
      spreads = []
      # convert text into spread
      spreads.push new Spread [new Point text.x - unit.x + 200, text.y - unit.y + 200, text.lexiles], text.r for text in unit.texts

      # make noisy junction between points
      noisy = new ELA.graph.NoisyEdges()
      for spread, i in spreads
        if spreads[i+1]
          start = spreads[i].points[0]
          end = spreads[i+1].points[0]

          z = start.z

          # create an edge
          edge =
            start : start
            end   : end
            # reflect the line segment between points
            right : new Point start.x, end.y, z
            left  : new Point end.x, start.y, z

          # make it noisy
          junction_path = noisy.build edge, 100

          # set z value depending on the distance
          for point in junction_path
            #nearest = if point.distanceTo start < point.distanceTo end then start else end
            point.z*= 0.7 if point!=start and point!=end

          igen.junction_points = igen.junction_points.concat junction_path


      # create spread array
      for junc_point in igen.junction_points
        add_area new Spread [junc_point], 100

      for spread in spreads
        add_area spread

    process()


    this.link_data last_layer

  altitude: ->


  link_data: (layer) ->
    # modifying voronoi diagram data
    # adding related edges and points into cells
    for edge in layer.edges
      edge.cells = []
      for cell, i in layer.cells
        if cell.surface # do it only for cells with defined surface, not to lose extra performance on unused cells
          cell.point = layer.points[i] # cell -> point relation
          layer.points[i].cell = cell
          if layer.points[i] == edge.left or layer.points[i] == edge.right
            unique = true
            edge.cells.push cell
            for existent in cell.edges
              if existent == edge
                unique = false
                break

            if unique
              cell.edges.push edge
              edge.path = layer.noisy_edges.build edge

    for cell in layer.cells
      if cell.surface
        cell.path = layer.sew_cell cell
    #console.log cell.path

    # define coastline edges
    coastline_edges = []
    for edge in layer.edges
      if edge.cells.length == 1
        coastline_edges.push edge
        edge.cells[0].surface = 'beach'

    a = layer.sew_cell {edges: coastline_edges}, this.coastline
    this.coastline.push a

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
  coastline: null
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

    for spread_point in spread.points
      for cell, i in layer.cells
        if cell.centroid.distanceTo(spread_point) <= spread.radius and not_overflow cell
          selected_cells.push cell
          cell.surface = 'land' # define selected cells as land

          alt_sum = 0
          for v in cell.vertices

            rand = Math.floor((Math.random()*3)+1) # random from 1 to 3
            spread_altitude = spread_point.z
            linear_fall_value = spread_altitude / spread.radius
            #linear_fall_value *= linear_fall_value
            distance_to_spread_point = spread_point.distanceTo(v)
            altitude = spread_altitude - linear_fall_value * distance_to_spread_point * (this.id+1) / rand

            v.z = Math.round(altitude) if v.z < altitude
            alt_sum += v.z
          this.points[i].z = Math.round(alt_sum / cell.vertices.length)


    selected_cells

  get_selected_vertices : (cells) ->
    res = []
    res = res.concat cell.vertices for cell in cells
    res

  sew_cells : (cells) ->


  sew_cell : (cell, pieces = []) ->
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
      pieces.push path

      sew edges, [] if edges.length

      path

    r = sew(cell.edges.slice(0))
    r

class Trace
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

$ ->

  init = (session) ->
    elaSession = session
    elaUnit = elaSession.current

    size    = [elaUnit.w+400, elaUnit.h+400]
    igen    = new ELA.Island(size, [100,200,1500])
    ELA.DATA.VoronoiStack = igen

    #console.log igen.layers[0].points[0]

    igen.SPREADS = []
    canvas  = new ELA.Canvas($('#trace_voronoi_canvas'), size)
    igen.canvas = canvas # for debug

    layer1  = igen.layers[0]
    layer2  = igen.layers[1]
    last_layer  = igen.layers[igen.layers.length-1]

    trace1   = new Trace(igen, layer1, canvas)
    trace2   = new Trace(igen, layer2, canvas)
    trace    = new Trace(igen, last_layer, canvas)
    igen.trace = trace
    ELA.trace = trace

    igen.create elaUnit

    #trace.shred "#fff", "#ccc"
    #console.log cell.point for cell in last_layer.cells
    #trace.peaks()
    trace.draw()
    #canvas.point point, point.z + '' for point in igen.junction_points
    trace.coastline()

    #    for edge in igen.layers[2].edges
    #      canvas.stroke(5,'black').vector edge.path if edge.cells.length == 1

    $('#trace_shred').click ->
      #trace.shred null, 'black'
      trace.coastline()
    #canvas.stroke(1, 'black').vector igen.pieces[1]

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

  ELA.DATA.json.onLoad((data) ->
    $('#trace_voronoi_next').click ->
      init(ELA.DATA.session)
      $('#trace_voronoi_controls').show()
  )


