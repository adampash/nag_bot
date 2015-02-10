// Generated by CoffeeScript 1.8.0
(function() {
  var JobStatus, Nag, SlackNotify, config, days, moment;

  config = require('cloud/config');

  SlackNotify = require('cloud/lib/slack_notifier');

  Nag = require('cloud/models/nag');

  JobStatus = require('cloud/models/job_status');

  moment = require('cloud/lib/moment-timezone-with-data');

  days = ["SU", "M", "T", "W", "TH", "F", "S"];

  exports.initialize = function() {
    return Parse.Cloud.job("send_nags", function(request, status) {
      var nags_sent, now;
      nags_sent = 0;
      now = new Date();
      return JobStatus.findOrCreate().then(function(job_status) {
        var current_time, day, last_run;
        day = days[parseInt(moment(new Date()).tz("America/New_York").format('d'))];
        last_run = parseInt(moment(job_status.get('last_run_at')).tz("America/New_York").format('HHmm'));
        current_time = parseInt(moment(new Date()).tz("America/New_York").format('HHmm'));
        console.log("TIME: " + current_time);
        console.log("DAY: " + day);
        return Nag.findAllEach({
          containsAll: {
            days: [day]
          },
          greaterThan: {
            time: last_run
          },
          lessThanOrEqualTo: {
            time: current_time
          }
        }).each(function(nag) {
          var msg;
          msg = nag.get('message');
          console.log("Nag time: " + (nag.get('time')));
          console.log("NAG: " + (nag.get('message')));
          SlackNotify.notify(msg, {
            icon_emoji: ':nail_care:',
            channel: nag.get('channel')
          });
          return nags_sent++;
        }).then(function() {
          job_status.set('last_run_at', now);
          return job_status.save();
        }).then(function() {
          return status.success("Sent " + nags_sent + " nags");
        }, function(err) {
          return status.error(err);
        });
      });
    });
  };

}).call(this);
