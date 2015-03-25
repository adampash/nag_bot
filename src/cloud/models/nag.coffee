ParseFinder = require 'cloud/mixins/finder'
SlackNotify = require('cloud/lib/slack_notifier')

module.exports = Nag = ParseFinder.extend "Nag",
  notify: ->
    # msg = @get 'message'
    you_or_person = if "@#{@get('created_by')}" is @get('channel') 
      "you"
    else
      @get('created_by')
    channel_or_person = if @get('channel')[0] is "@"
      ""
    else
      "@channel "
    msg = "#{channel_or_person}#{@getStarter()} #{you_or_person} wanted me to remind you to *#{@get 'message'}*"
    console.log "Nag time: #{@get 'time'}"
    console.log "NAG: #{@get 'message'}"
    SlackNotify.notify msg,
      icon_emoji: ':baby_bottle:'
      channel: @get('channel')

  getStarter: ->
    starters = [
      "Oh hi!"
      "Hey you!"
      "Oh btw:"
      "Ooooo!"
      "I just remembered:"
    ]
    starters[Math.floor(Math.random()*starters.length)]

,
  create: (text, creator) ->
    channel = text.match(/\B[@#]\w+\b/)[0]
    days = @getDays(text)
    time = text.match(/(at)?\s(\d+(:\d\d)?[a|p]m)\b/i)[2]
    message = text.match(/to\s(.+)$/i)[1]
    nag = new @(
      channel: channel
      days: days
      time: @convertToMilitaryTime(time)
      message: message
      created_by: creator
    )
    nag.save()

  getDays: (text) ->
    days = text.match(/(on)?\s(everyday|weekdays|daily)\b/i)
    if days?
      days = days[2]
      if days is "everyday" or days is "daily"
        days = "mon,tue,wed,thu,fri,sat,sun"
      else if days is "weekdays"
        days = "mon,tue,wed,thu,fri"
      days = days.toUpperCase().split(',')
    else
      days = []
      if text.match(/\b((mon(day)?))\b/)
        days.push "MON"
      if text.match(/\b((tue((s)?day)?))\b/)
        days.push "TUE"
      if text.match(/\b((wed(nesday)?))\b/)
        days.push "WED"
      if text.match(/\b((thu((r(s)?(day)?)?)?))\b/)
        days.push "THU"
      if text.match(/\b((fri(day)?))\b/)
        days.push "FRI"
      if text.match(/\b((sat(urday)?))\b/)
        days.push "SAT"
      if text.match(/\b((sun(day)?))/)
        days.push "SUN"
    days

  convertToMilitaryTime: (time) ->
    ampm = time.match(/([a|p]m)/i)[1].toLowerCase()
    hours = time.match(/^(\d\d?):?/i)[1]
    if time.match(/^\d\d?:(\d\d)/i)?
      minutes = time.match(/^\d\d?:(\d\d)/i)[1]
    else
      minutes = "00"
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

