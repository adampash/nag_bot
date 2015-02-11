config = require 'cloud/config'
Nag = require 'cloud/models/nag'
SlackNotify = require('cloud/lib/slack_notifier')

exports.initialize = ->

  # /nag channel/person [daily/weekdays/tuesdays/m,w,f/etc at [4pm/3am] to [message]
  Parse.Cloud.define "new_nag", (request, response) ->
    {token, text, channel_id, user_name} = request.params
    if token is config.slack.token

      if text.split(' ').length < 6
        if text is "help"
          return response.success "Usage: /nag [#channel|@person] [everyday|weekdays|m,w|etc] at [4pm|7:30am] to [do something]"
        else
          return response.error "Make sure you've got all the pieces"

      Nag.create(text, user_name).then (nag) ->
        response.success "I'll remind #{nag.get 'channel'} to #{nag.get 'message'} on #{nag.get('days').join(',')} at #{nag.get('time')}"


      , (err) ->
        response.error err
    else
      response.error 'bad token'
