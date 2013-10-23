$ ->
  ELA.DATA.json.onLoad((data) ->
    $('#trace_voronoi_next').click ->
      $("#previously_rendered_island").hide()
      ELA.Island.create(ELA.DATA.session)
      $('#trace_voronoi_controls').show()

    # ELA.Processing.scheme data if $('canvas#island')[0]


  )