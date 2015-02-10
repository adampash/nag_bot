config = require 'cloud/config'
{$} = require('cloud/lib/ajax')

module.exports = SlackNotify =

  url: config.slack.url

  notify: (msg, options) ->
    {channel, username, icon_emoji} = options

    channel = channel ? '#notifications'
    icon_emoji = icon_emoji ? ':package:'
    username = username ? 'NagBot'

    payload =
      text: msg
      channel: channel
      username: username
      icon_emoji: icon_emoji

    $.ajax
      url: @url
      method: 'POST'
      dataType: 'json'
      params: payload
      success: (data) =>
        console.log 'success'
        # complete api.normalizeETA(data)
        # else
        #   complete(data, false)
      error: (error) ->
        console.log 'something went wrong'
        console.log error
        complete 'something went wrong'
