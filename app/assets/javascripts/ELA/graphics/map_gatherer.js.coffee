class ELA.graph.MapGatherer
  canvas  : null
  session : null
  images  : null
  width   : null
  options : {}
  units   :
    present : []
    absent  : []
  constructor : (session, canvas, options) ->
    this.options = options
    this.session = session
    this.canvas = canvas
    this.images = []
    this.options.start() if this.options.start
    this.gather()
    console.log this.images
    this.canvas.el.width += 300 # magic number, add additional pixels to canvas due to temporary circles enlargment

  gather : ->
    mg = this
    handledImages = 0
    uid = (+new Date())
    success_callback = this.options.success || ->

    place = (unit) ->
      img = new Image()
      s3url = 'http://elamapping.s3.amazonaws.com'
      final_url = s3url + '/assembly/maps/' + mg.session.id + '.png?uid=' + uid
      $(img).attr('crossOrigin','use-credentials')
      img.src = s3url + "/assembly/units/" + unit.id + ".png?uid=" + uid

      # save onto cloud if all images are loaded
      storeIfDone = ->

        if ++handledImages == mg.session.units.length
          unit_list = (units) ->
            res = (unit.data.letter + ' - ' +unit.data.name for unit in units)
            res.join("\n")

          found     = ''
          not_found = ''
          found     = unit_list mg.units.present
          not_found = unit_list mg.units.absent

          mg.canvas.store ->
            console.log 'Loaded ' + final_url
            success_callback()
            alert "Done!" +
                  "\nFound images:\n" + (found || 'none') +
                  (("\nNot found:\n" + not_found if not_found) || '')
      #initMap('session-map', final_url, this.width, this.height)


      $(img)
        .load  ->
          mg.canvas.img img, unit.x_left, unit.y_top
          mg.images.push img
          console.log 'Unit ' + unit.id + ' ok ' + img.width
          mg.units.present.push unit
          storeIfDone()
        .error ->
          console.log 'Unit ' + unit.id + ' image not found'
          mg.units.absent.push unit
          storeIfDone() # still store to debug. must not be on production

    place unit for unit in this.session.units