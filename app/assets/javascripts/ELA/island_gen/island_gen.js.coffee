ELA.Island.create = (session) ->
  button = $('#trace_voronoi_next')
  button.attr('disabled', 'disabled').html('Rendering...')
  elaSession = session
  elaUnit = elaSession.current

  size    = [elaUnit.w+400, elaUnit.h+400]
  igen    = new ELA.MapGen.Factory(size, [100,200,1500])
  ELA.DATA.VoronoiStack = igen

  #console.log igen.layers[0].points[0]

  igen.SPREADS = []
  canvas  = new ELA.Canvas($('#trace_voronoi_canvas'), size)
  igen.canvas = canvas # for debug

  layer1  = igen.layers[0]
  layer2  = igen.layers[1]
  last_layer  = igen.layers[igen.layers.length-1]

  trace1   = new ELA.MapGen.Trace(igen, layer1, canvas)
  trace2   = new ELA.MapGen.Trace(igen, layer2, canvas)
  trace    = new ELA.MapGen.Trace(igen, last_layer, canvas)
  igen.trace = trace
  ELA.trace = trace

  igen.create elaUnit

  #trace.shred "#fff", "#ccc"
  #console.log cell.point for cell in last_layer.cells
  #trace.peaks()
  trace.draw()
  #canvas.point point, point.z + '' for point in igen.junction_points
  trace.coastline()
  button.attr('disabled', 'disabled').html('Storing...')
  canvas.store( -> button.removeAttr('disabled').html('Re-render') )

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