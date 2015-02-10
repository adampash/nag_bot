exports.$ =
  ajax: (options={}, splitParams=true) ->
    if splitParams
      [url, oldparams] = options.url.split("?")
    else
      url = options.url

    method = options.method ? "GET"

    data =
      method: method
      body: options.params
      url: url
      headers:
        'Content-Type': 'application/json'
      success: (data) ->
        if options.dataType is 'json'
          data.text = JSON.parse data.text
        options.success data.text if options.success?
      error: (data) ->
        options.error data if options.error?
        console.error('Request failed with response code ' + data.status)
    data.params = options.params if splitParams

    Parse.Cloud.httpRequest data
