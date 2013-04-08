# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

draw =
  c : null  # canvas context - shouf be defined before using object

  # trace circle (x, y, radius, inner text)
  circle : (x, y, r, text) ->
    text = text || ''
    this.c.fillStyle = '#095'
    this.c.beginPath()
    this.c.arc(x, y, r, 0, Math.PI*2, true)
    this.c.closePath()
    this.c.fill()
    this.text(text, x, y, '#fff') if text

  # trace text
  text : (text, x, y, color) ->
    this.c.textBaseline="middle"
    this.c.textAlign="center"
    this.c.fillStyle = color || "#000"
    this.c.fillText(text, x, y)

  unit : (unit) ->
    x = 0
    prev = 0
    push = (text) ->
      x += text.lessons * 5 + prev
      prev = text.lessons * 5
      draw.circle(x, 200, text.lessons * 5, '')


    push text for text in unit.texts


json =
  url : null
  get :(callback) ->
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
  canvas = $('canvas#island')[0]
  canvas.width = 800
  canvas.height = 400
  render_button = $("#renderIslandButton")

  # objects initialization
  draw.c = canvas.getContext('2d')
  json.url = render_button.attr "href"

  render_button.click ->
    json.get ( (data) -> draw.unit(data.units[2]) )
    #draw.unit(data.units[0])
    false
  this