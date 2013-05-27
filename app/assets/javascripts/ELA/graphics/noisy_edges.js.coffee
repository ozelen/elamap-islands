# Annotate each edge with a noisy path, to make maps look more interesting.
# Original AS at https://github.com/amitp/mapgen2/blob/master/NoisyEdges.as
# Author: amitp@cs.stanford.edu
# Ported on CoffeeScript by Oleksiy Zelenyuk

class ELA.graph.NoisyEdges
  NOISY_LINE_TRADEOFF = 0.5
  path0 : []
  path1 : []
  canvas : null

  constructor : () ->


  build_noisy_edges : (map, lava, random) ->
    point = new Point 0,0
    points = []
    for p in map.cells
      for edge in p.edges
        if edge.d0 and edge.d1 and edge.v0 and edge.v1 and !this.path0[edge.index]
          f = NOISY_LINE_TRADEOFF
          t = point.interpolate(edge.v0.point, edge.d0.point, f)
          q = point.interpolate(edge.v0.point, edge.d1.point, f)
          r = point.interpolate(edge.v1.point, edge.d0.point, f)
          s = point.interpolate(edge.v1.point, edge.d1.point, f)

          min_length = 10

#          min_length = 3    if edge.d0.biome != edge.d1.biome
#          min_length = 100  if edge.d0.ocean and edge.d1.ocean
#          min_length = 1    if edge.d0.coast and edge.d1.coast
#          min_length = 1    if edge.river or lava.lava[edge.index]

          this.path0[edge.index] = this.build_noisy_segments(random, edge.v0.point, t, edge.midpoint, q, min_length)
          this.path1[edge.index] = this.build_noisy_segments(random, edge.v1.point, s, edge.midpoint, r, min_length)

  # Helper function: build a single noisy line in a quadrilateral A-B-C-D,
  # and store the output points in a Vector.
  build_noisy_segments : (random, A, B, C, D, min_length) ->
    self = this
    points = []
    point = new Point 0,0
    i=0
    subdivide = (a, b, c, d) ->
      return if a.subtract(c).length() < min_length or b.subtract(d).length() < min_length

      p = random.next_double_range(0.2, 0.8) # vertical (along A-D and B-C)
      q = random.next_double_range(0.2, 0.8) # horizontal (along A-B and D-C)

      # Midpoints
      e = point.interpolate a, d, p
      f = point.interpolate b, c, p
      g = point.interpolate a, b, q
      i = point.interpolate d, c, q

      # Central point
      h = point.interpolate e, f, q

      # Divide the quad into subquads, but meet at H
      s = 1.0 - random.next_double_range(-0.4, +0.4) # vertical (along A-D and B-C)
      t = 1.0 - random.next_double_range(-0.4, +0.4) # horizontal (along A-B and D-C)

      subdivide(a, point.interpolate(g, b, s), h, point.interpolate(e, d, t))
      points.push h
      subdivide(h, point.interpolate(f, c, s), c, point.interpolate(i, d, t))

    points.push A
    subdivide A, B, C, D
    points.push C

    points



$ ->
  $('#trace_noisy_line').click ->
    canvas  = new ELA.Canvas($('#trace_voronoi_canvas'), [300,300])

    nedge = new ELA.graph.NoisyEdges()
    nedge.canvas = canvas
    random  = new ELA.math.NumGen
    a = new Point 10,10
    b = new Point 210,10
    c = new Point 210,210
    d = new Point 10,210
    #canvas.points [a,b,c,d]

    quad = [a,b,c,d]
    points = nedge.build_noisy_segments random, a, b, c, d, 10

    #canvas.stroke(2, 'red').vector quad
    #canvas.points quad

    canvas.stroke(2, 'blue').vector points

    #canvas.points points