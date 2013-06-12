class ELA.Processing.Square
  sq = this
  vertices:
    top:
      left   : new ELA.Processing.Point(0,0)
      right  : new ELA.Processing.Point(0,0)
    bottom   :
      left   : new ELA.Processing.Point(0,0)
      right  : new ELA.Processing.Point(0,0)

  edges      :
    top      : null
    right    : null
    bottom   : null
    left     : null

  constructor: (w, h) ->
    v = this.vertices
    e = this.edges
    e.top      = (val=null) -> if val then v.top.left.y    = val; v.top.right.y    = val else v.top.right.y
    e.right    = (val=null) -> if val then v.top.right.x   = val; v.bottom.right.x = val else v.top.right.x
    e.bottom   = (val=null) -> if val then v.bottom.left.y = val; v.bottom.right.y = val else v.bottom.left.y
    e.left     = (val=null) -> if val then v.top.left.x    = val; v.bottom.left.x  = val else v.bottom.left.x

    e.bottom(h)
    e.right(w)

  height    : -> this.dist(this.edges.top(), this.edges.bottom())
  dist      : (a, b) -> -a + b # find difference (distance) between values on axis
  set       : (x_left, y_top, x_right, y_bottom) ->
    v = this.vertices
    v.top.left.x     = v.bottom.left.x  = x_left
    v.top.left.y     = v.top.right.y    = y_top
    v.top.right.x    = v.bottom.right.x = x_right
    v.bottom.left.y  = v.bottom.right.y = y_bottom