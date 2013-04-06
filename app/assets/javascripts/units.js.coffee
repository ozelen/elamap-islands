# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

drawUnit = () ->
  jQuery.ajax '/units/3.json',
         type="GET"
         dataType: 'json'
         error: (jqXHR, textStatus, errorThrown) ->
           alert "AJAX Error: #{textStatus}"
         success: (data, textStatus, jqXHR) ->
           alert(data)


$(document).ready ->
  $("#renderIslandButton").click ->
    drawUnit()
  this