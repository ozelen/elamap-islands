ELA.Processing.TRACE =
  c       : null  # canvas context - must be defined before using object
  measure : null
  # trace circle (x, y, radius, inner text)
  circle : (x, y, r, color) ->
    text = text || ''
    c = this.c
    c.fillStyle = color
    c.lineWidth = 2
    c.strokeStyle = "#000"
    c.beginPath()
    c.arc(x, y, r, 0, Math.PI*2, true)
    c.closePath()
    c.fill()
    c.stroke()
  #this.text(text, x, y, '#fff') if text

  lexiles : (x, y, lexiles) ->
    x = Math.round(x)
    c = this.c
    h = lexiles / 20
    c.lineWidth = 1
    c.strokeStyle = "#000"
    c.beginPath()
    c.moveTo(x, y)
    c.lineTo(x, y-h)
    c.closePath()
    c.stroke()

  # trace text
  label : (text, x, y, color) ->
    c = this.c
    c.textBaseline = "middle"
    c.textAlign = "center"
    c.fillStyle = color || "#000"
    c.fillText(text, x, y)

  frame : (x1,y1,x2,y2) ->
    w = x2 - x1
    h = y2 - y1
    c = this.c
    c.lineWidth = 1
    c.strokeStyle = "#ccc"
    c.strokeRect(x1,y1,w,h)

  scale : ->
    c = this.c
    m = this.measure
    line = (num) ->
      y = Math.round( num * m.h / m.y )
      c.strokeStyle = "#ccc"
      c.outlineWidth = 1
      c.beginPath()
      c.moveTo(0,y)
      c.lineTo(m.w, y)
      c.closePath()
      c.stroke()
    line num for num in [1..m.h]

  clear : ->
    this.c.clearRect( 0, 0, this.measure.w, this.measure.h )

  rnd_color : ->
    letters = '0123456789ABCDEF'.split ''
    color = '#'
    color += letters[Math.round(Math.random() * 15)] for i in [0..5]
    color

  log : (msg) ->
    log = $('textarea#log')
    d = new Date()
    time = d.getHours() + ':' + ':' + d.getMinutes() + ':' + d.getSeconds()
    log.val(log.val() + '[' + time + '] ' + msg)
    console.log msg