# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

measure =
  x : 5
  y : 8
  w : 1170
  h : 400
  unit : null

draw =
  c : null  # canvas context - shouf be defined before using object

  # trace circle (x, y, radius, inner text)
  circle : (x, y, r, color) ->
    text = text || ''
    c = this.c
    c.fillStyle = color
    c.beginPath()
    c.arc(x, y, r, 0, Math.PI*2, true)
    c.closePath()
    c.fill()
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

  unit : (unit, x=0) ->
    x_left = x
    prev_r = 0
    y_bottom = 0

    if measure.unit
      color = if unit.id == measure.unit then '#095' else '#ccc'
    else
      color = this.rnd_color()

    push = (text) ->
      r = text.lessons * measure.x / 2
      y = text.genre * measure.h / measure.y
      y_bottom = y + r if y_bottom < y + r
      x += r + prev_r
      prev_r = r
      draw.circle(x, y, r, color)
      draw.lexiles(x, y, text.lexiles)

    push text for text in unit.texts
    x_right = x+prev_r
    x_mid = x_left + (x_right - x_left) / 2
    draw.label(unit.name, x_mid, y_bottom + 10)

    x_right # return end point of island






  session : (session) ->
    whitespace = 20
    whitespaces = (session.units.length - 1) * whitespace
    x = -whitespace # start x point in pixels
    measure.x = (measure.w - whitespaces ) / session.lessons
    x = this.unit unit, x+whitespace for unit in session.units

  rnd_color : ->
    letters = '0123456789ABCDEF'.split ''
    color = '#'
    color += letters[Math.round(Math.random() * 15)] for i in [0..5]
    color
json =
  url : null
  get : (callback) ->
    js = null
    jQuery.ajax this.url,
              type="post",
              dataType: 'json'
    .fail (jqXHR, textStatus, errorThrown) ->
      alert "AJAX Error: #{textStatus}"
    .done (data, textStatus, jqXHR) ->
      callback(data)
    js


$ ->
  # initial objects and settings
  $canvas = $('canvas#island')
  canvas = $canvas[0]
  if canvas
    canvas.width = measure.w
    canvas.height = measure.h
    measure.unit = parseInt( $canvas.attr("unit") )
    draw.c = canvas.getContext('2d')
    json.url = $canvas.attr "src"
    json.get ( (data) -> draw.session(data) )
