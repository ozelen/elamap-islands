
class AWS 
  file    : null
  fd      : null
  key     : null
  bucket  : null

  constructor : (bucket) ->
    this.bucket = bucket
  
  init : () ->
    this.fd = new FormData()
    this.key = "events/" + (new Date).getTime() + '-' + this.file.name
    this.fd.append 'key', this.key
    this.fd.append 'acl', 'public-read'
    this.fd.append 'Content-Type', this.file.type
    this.fd.append 'AWSAccessKeyId', 'AKIAJ6ESJRHGRTWVBXJQ'
    this.fd.append 'policy', 'YOUR POLICY'
    this.fd.append 'signature','YOUR SIGNAURE'
    this.fd.append "file", this.file

  upload : (file) ->
    this.file = file
    this.init()
    xhr = getXMLHTTPObject()
    xhr.upload.addEventListener "progress", this.uploadProgress, false
    xhr.addEventListener "load", this.uploadComplete, false
    xhr.addEventListener "error", this.uploadFailed, false
    xhr.addEventListener "abort", this.uploadCanceled, false
  
    xhr.open 'POST', 'https://'+this.bucket+'.s3.amazonaws.com/', true #MUST BE LAST LINE BEFORE YOU SEND
  
    xhr.send(fd)

  msg : (msg) ->
    alert msg

  uploadProgress : (p) -> console.log 'Progress ' + p + '...'

  uploadComplete :  -> this.msg 'complete!'
  uploadFailed :    -> this.msg 'failed!'
  uploadCanceled :  -> this.msg 'canceled!'

window.awsUpload = new AWS('elamap-islands')