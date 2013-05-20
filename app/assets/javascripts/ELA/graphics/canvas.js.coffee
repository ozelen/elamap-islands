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