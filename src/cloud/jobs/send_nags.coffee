config = require 'cloud/config'
Nag = require 'cloud/models/nag'
JobStatus = require 'cloud/models/job_status'
moment = require('cloud/lib/moment-timezone-with-data')
# days = ["SU", "M", "T", "W", "TH", "F", "S"]

exports.initialize = ->
  Parse.Cloud.job "send_nags", (request, status) ->
    nags_sent = 0
    now = new Date()
    JobStatus.findOrCreate().then (job_status) ->
      day = moment(new Date()).tz("America/New_York").format('ddd').toUpperCase()
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
        nag.notify()
        nags_sent++

      .then ->
        job_status.set('last_run_at', now)
        job_status.save()
      .then ->
        status.success "Sent #{nags_sent} nags"
      , (err) ->
        status.error(err)

