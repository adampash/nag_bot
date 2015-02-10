config = require 'cloud/config'
Nag = require 'cloud/models/nag'

convertToMilitaryTime = (time) ->
  ampm = time.match(/([a|p]m)/i)[1].toLowerCase()
  hours = time.match(/^(\d\d?):?/i)[1]
  if time.match(/^\d\d?:(\d\d)/i)?
    minutes = time.match(/^\d\d?:(\d\d)/i)[1]
  else
    minutes = "00"
  console.log ampm
  console.log hours
  console.log minutes
  if ampm is "am"
      militaryHours = hours
      # check for special case: midnight
      militaryHours = "00" if militaryHours is "12"
  else
    if ampm is "pm"
      # get the interger value of hours, then add
      tempHours = parseInt( hours ) + 2
      # adding the numbers as strings converts to strings
      if tempHours < 10
        tempHours = "1" + tempHours
      else
        tempHours = "2" + (tempHours - 10)
      # check for special case: noon
      tempHours = "12" if tempHours is "24"
      militaryHours = tempHours
  parseInt(militaryHours + minutes)

exports.initialize = ->

  # /nag channel/person [daily/weekdays/tuesdays/m,w,f/etc at [4pm/3am] to [message]
  Parse.Cloud.define "new_nag", (request, response) ->
    {token, text} = request.params
    if token is config.slack_token

      if text.split(' ').length < 6
        if text is "help"
          return response.success "Usage: /nag [#channel|@person] [everyday|weekdays|m,w|etc] at [4pm|7:30am] to [do something]"
        else
          return response.error "Make sure you've got all the pieces"

      channel = text.split(' ')[0]
      days = text.match(/(on)?\s(everyday|weekdays|daily|[,|M|T|W|Th|F]*)\b/i)[2]
      if days is "everyday" or days is "daily"
        days = "m,t,w,th,f,s,su"
      else if days is "weekdays"
        days = "m,t,w,th,f"
      days = days.toUpperCase().split(',')
      time = text.match(/at\s(\d+(:\d\d)?[a|p]m)\b/i)[1]
      message = text.match(/to\s(.+)$/i)[1]
      nag = new Nag
        channel: channel
        days: days
        time: convertToMilitaryTime(time)
        message: message
      nag.save().then (nag) ->
        response.success "I'll remind #{channel} to #{message} on #{days.join(',')} at #{time}"


      , (err) ->
        response.error err
    else
      response.error 'bad token'



      #   message: "Time to do that thing!"
