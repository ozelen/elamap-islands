class ELA.Processing.Unit
  texts   : []
  data    : []
  measure : {}
  id      : 0
  frame   : null
  constructor: (unit, measure) ->
    this.data = unit
    this.id = unit.id
    this.measure = measure
    texts = []
    texts.push(new ELA.Processing.Text(text, this.measure)) for text in unit.texts
    this.texts = texts
    this.frame = new ELA.Processing.Square(0,0)

  set: (x) ->
    this.x_left  = x
    this.y_top   = this.measure.h
    this.y_bot   = 0
    this.y_right = 0
    prev_r = 0
    measure = this.measure
    un = this

    if measure.unit
      color = if this.data.id == measure.unit then '#095' else '#ccc'
    else
      color = ELA.fixtures.scheme_colors.shift() || ELA.Processing.TRACE.rnd_color()

    push = (text) ->
      r = text.data.lessons * measure.x / 2
      y = measure.h - text.data.genre * measure.h / measure.y
      un.y_bot  = y + r if un.y_bot < y + r
      un.y_top  = y - r if un.y_top > y - r
      x += r + prev_r
      prev_r = r

      text.set x, y, r, color

    push text for text in this.texts

    this.x_right = x+prev_r
    x_mid = this.x_left + (this.x_right - this.x_left) / 2
    ELA.Processing.TRACE.label(this.data.name, x_mid, this.y_bot + 10)
    # TRACE.frame(x_left, y_top, x_right, y_bot)
    this.data.x = this.x_left
    this.data.y = this.y_top
    this.data.w = this.x_right - this.data.x
    this.data.h = this.y_bot - this.data.y
    edge = measure.map.edges
    edge.bottom(this.y_bot)  if this.y_bot   > edge.bottom()
    edge.right(this.x_right) if this.x_right > edge.right()
    edge.left(this.x_left)   if this.x_left  < edge.left()
    edge.top(this.y_top)     if this.y_top   < edge.top()
    this.frame.set this.x_left, this.y_top, this.x_right, this.y_bot
    this.x_right # return end point of island

  draw: ->
    text.draw() for text in this.texts