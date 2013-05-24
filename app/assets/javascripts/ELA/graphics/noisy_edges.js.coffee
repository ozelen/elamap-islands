# Annotate each edge with a noisy path, to make maps look more interesting.
# Original AS at https://github.com/amitp/mapgen2/blob/master/NoisyEdges.as
# Author: amitp@cs.stanford.edu
# Ported on CoffeeScript by Oleksiy Zelenyuk

class ELA.graph.NoisyEdges
  NOISY_LINE_TRADEOFF = 0.5
  path0 : []
  path1 : []

  constructor : () ->


  build_noisy_edges : (map, lava, random) ->
    point = new Point 0,0
    points = []
    for p in map.cells
      for edge in p.edges
        if edge.d0 and edge.d1 and edge.v0 and edge.v1 and !this.path0[edge.index]
          f = NOISY_LINE_TRADEOFF
          t = point.interpolate(edge.v0.point, edge.d0.point, f)
          t = point.interpolate(edge.v0.point, edge.d1.point, f)
          t = point.interpolate(edge.v1.point, edge.d0.point, f)
          t = point.interpolate(edge.v1.point, edge.d1.point, f)

          min_length = 10

          min_length = 3    if edge.d0.biome != edge.d1.biome
          min_length = 100  if edge.d0.ocean and edge.d1.ocean
          min_length = 1    if edge.d0.coast and edge.d1.coast
          min_length = 1    if edge.river or lava.lava[edge.index]

          this.path0[edge.index]


  build_noisy_segments : (random, A, B, C, D, min_length) ->
    point = new Point 0,0
    subdivide = (a, b, c, d) ->
      return if a.subtract(c).length < min_length or b.subtract(d).length < min_length

      p = 1.0 - random.next_double_range(0.2, 0.8) # vertical (along A-D and B-C)
      q = 1.0 - random.next_double_range(0.2, 0.8) # horizontal (along A-B and D-C)

      # Midpoints
      E = point.interpolate A, D, p
      F = point.interpolate B, C, p
      G = point.interpolate A, B, q
      I = point.interpolate D, C, q

      # Central point
      H = point.interpolate E, F, q

      # Divide the quad into subquads, but meet at H
      s = 1.0 - random.next_double_range(-0.4, +0.4) # vertical (along A-D and B-C)
      t = 1.0 - random.next_double_range(-0.4, +0.4) # horizontal (along A-B and D-C)

      subdivide(A, point.interpolate(G, B, s), H, point.interpolate(E, D, t))
      points.push H
      subdivide(H, point.interpolate(F, C, s), C, point.interpolate(I, D, t))

    points.push A
    subdivide A, B, C, D
    points.push C

    points
