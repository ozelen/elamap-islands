class ELA.MapGen.Layer
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