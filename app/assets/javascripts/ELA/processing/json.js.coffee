ELA.Processing.json =
  url : null
  data : null
  callbacks : []
  get : (cb) ->
    self = this
    jQuery.ajax this.url,
                type="post",
                dataType: 'json'
      .fail (jqXHR, textStatus, errorThrown) ->
        alert "AJAX Error: #{textStatus}"
      .done (data, textStatus, jqXHR) ->
        ELA.Processing.json.data = data
        cb(data)
        callback(data) for callback in self.callbacks
    ELA.Processing.json.data

  onLoad : (func) ->
    this.callbacks.push func
    func() if this.data

ELA.DATA.json = ELA.Processing.json