$ ->
  ELA.DATA.json.onLoad((data) ->
    $('#trace_voronoi_next').click ->
      ELA.Island.create(ELA.DATA.session)
      $('#trace_voronoi_controls').show()
  )