class ELA.Processing.Text
  data    : {}
  x       : null
  y       : null
  r       : null
  color   : null
  measure : {}
  constructor: (text, measure) ->
    this.data = text
    this.measure = measure

  draw : ->
    ELA.Processing.TRACE.circle(this.x, this.y, this.r, this.color)
    ELA.Processing.TRACE.lexiles(this.x, this.y, this.data.lexiles)

  set : (x,y,r,color) ->
    this.x = this.data.x = x
    this.y = this.data.y = y
    this.r = this.data.r = r
    this.color = color
    this.measure.max_lexiles = this.data.lexiles if this.data.lexiles > this.measure.max_lexiles
