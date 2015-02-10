config = require 'cloud/config'
SlackNotify = require('cloud/lib/slack_notifier')
Nag = require 'cloud/models/nag'
JobStatus = require 'cloud/models/job_status'
moment = require('cloud/lib/moment-timezone-with-data')
days = ["SU", "M", "T", "W", "TH", "F", "S"]

exports.initialize = ->
  Parse.Cloud.job "send_nags", (request, status) ->
    nags_sent = 0
    JobStatus.findOrCreate().then (job_status) ->
      day = days[parseInt moment(new Date()).tz("America/New_York").format('d')]
      # current_time = moment(new Date()).tz("America/New_York").format('h:mmA')
      last_run = parseInt(moment(job_status.get('last_run_at'))
        .tz("America/New_York")
        .format('HHmm'))
      current_time = parseInt(moment(new Date())
        .tz("America/New_York")
        .format('HHmm'))
      console.log "TIME: #{current_time}"
      console.log "DAY: #{day}"
      Nag.findAllEach(
        containsAll: {days: [day]}
        greaterThan: { time: last_run }
        lessThanOrEqualTo: { time: current_time }
      ).each (nag) ->
        msg = nag.get 'message'
        console.log "Nag time: #{nag.get 'time'}"
        console.log "NAG: #{nag.get 'message'}"
        SlackNotify.notify msg,
          icon_emoji: ':nail_care:'
          channel: nag.get('channel')
        nags_sent++

      .then ->
        job_status.set('last_run_at', new Date())
        job_status.save()
      .then ->
        status.success "Sent #{nags_sent} nags"
      , (err) ->
        status.error(err)

