class ELA.MapGen.Factory
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
    this.add_layer new ELA.MapGen.Layer(this.width, this.height, l), i for l, i in levels

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
      new_spread = new ELA.MapGen.Spread(layer.get_selected_vertices(cells), spread.radius / (igen.layers.length * 1))
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
      spreads.push new ELA.MapGen.Spread [new Point text.x - unit.x + 200, text.y - unit.y + 200, text.lexiles], text.r for text in unit.texts

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
        add_area new ELA.MapGen.Spread [junc_point], 100

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