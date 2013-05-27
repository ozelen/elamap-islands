#define ->
class ELA.Canvas
  $       : null # jQuery object
  el      : null # canvas html element
  s3      :
    url   : null
    bucket: null
    fname : null
  context : null
  constructor: (canvas, bounds = []) ->
    this.$  = canvas
    this.el = canvas[0]
    this.set_bounds bounds if bounds
    this.context = canvas[0].getContext('2d')
    this.s3.url = canvas.attr 's3url'
    this.s3.bucket = canvas.attr 's3bucket'
    this.s3.fname = canvas.attr 's3fname'
    this.style =
      fill : 'red'
      stroke :
        color : '#fff'
        width : 0.1
      text :
        color : '#fff'
    this.stroke this.style.stroke.width, this.style.stroke.color
    this.fill this.style.fill

  set_bounds: (bounds) ->
    this.el.width  = bounds[0] ? null
    this.el.height = bounds[1] ? null

  img : (image, x, y) ->
    console.log 'Place image on canvas: ', image, x, y
    this.context.drawImage(image, x, y)

  store: ( callback = -> ) ->
    console.log 'Store map'
    canvas_data = this.el.toDataURL "image/png"
    base64 = canvas_data.replace /^data:image\/(png|jpg);base64,/, ""
    s3 = this.s3
    $.post s3.url, {dir: s3.bucket, fname: s3.fname, data:base64}, callback

  clear: ->
    this.el.width = this.el.width

  stroke : (width, color) ->
    c = this.context
    c.lineWidth = width;
    c.strokeStyle = color;
    this

  fill : (color) ->
    this.context.fillStyle = color
    this.style.fill = color

  text : (text, point) ->
    c = this.context
    c.textBaseline="middle"
    c.textAlign="center"
    c.fillStyle = this.style.text.color
    c.fillText(text, point.x, point.y)
    c.fillStyle = this.style.fill
    this

  point : (point, text = '') ->
    c = this.context
    size = if text then 10 else 3
    c.beginPath()
    c.arc(point.x, point.y, size, 0, Math.PI*2, true)
    c.closePath()
    c.fill()
    text = text+''
    this.text text, point if text
    this

  points : (points) ->
    this.point point, i+'' for point, i in points

  line : (start, end) ->
    c = this.context
    c.beginPath()
    c.moveTo(start.x, start.y)
    c.lineTo(end.x, end.y)
    c.closePath()
    c.stroke()
    this

  vector : (points) ->
    #console.log points
    c = this.context
    line = (point) ->
      alert ''
      c.lineTo(point.x, point.y)

    c.beginPath()
    c.moveTo(points[0].x, points[0].y)

    this.line points[i], points[i+1] for i in [0...points.length-1]

    c.closePath()
    c.stroke()
    this
