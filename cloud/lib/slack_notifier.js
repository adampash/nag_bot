// Generated by CoffeeScript 1.8.0
(function() {
  var $, SlackNotify, config;

  config = require('cloud/config');

  $ = require('cloud/lib/ajax').$;

  module.exports = SlackNotify = {
    url: config.slack.url,
    notify: function(msg, options) {
      var channel, icon_emoji, payload, username;
      channel = options.channel, username = options.username, icon_emoji = options.icon_emoji;
      channel = channel != null ? channel : '#notifications';
      icon_emoji = icon_emoji != null ? icon_emoji : ':package:';
      username = username != null ? username : 'NagBot';
      payload = {
        text: msg,
        channel: channel,
        username: username,
        icon_emoji: icon_emoji
      };
      return $.ajax({
        url: this.url,
        method: 'POST',
        dataType: 'json',
        params: payload,
        success: (function(_this) {
          return function(data) {
            return console.log('success');
          };
        })(this),
        error: function(error) {
          console.log('something went wrong');
          console.log(error);
          return complete('something went wrong');
        }
      });
    }
  };

}).call(this);