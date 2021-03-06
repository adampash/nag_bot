// Generated by CoffeeScript 1.8.0
(function() {
  var Nag, SlackNotify, config;

  config = require('cloud/config');

  Nag = require('cloud/models/nag');

  SlackNotify = require('cloud/lib/slack_notifier');

  exports.initialize = function() {
    return Parse.Cloud.define("new_nag", function(request, response) {
      var channel_id, text, token, user_name, _ref;
      _ref = request.params, token = _ref.token, text = _ref.text, channel_id = _ref.channel_id, user_name = _ref.user_name;
      if (token === config.slack.token) {
        if (text.split(' ').length < 6) {
          if (text === "help") {
            return response.success("Usage: /nag [#channel|@person] [everyday|weekdays|m,w|etc] at [4pm|7:30am] to [do something]");
          } else {
            return response.error("Make sure you've got all the pieces");
          }
        }
        return Nag.create(text, user_name).then(function(nag) {
          return response.success("I'll remind " + (nag.get('channel')) + " to " + (nag.get('message')) + " on " + (nag.get('days').join(',')) + " at " + (nag.get('time')));
        }, function(err) {
          return response.error(err);
        });
      } else {
        return response.error('bad token');
      }
    });
  };

}).call(this);
