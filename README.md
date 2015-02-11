# Setup
1. Create an app in Parse
1. Set up an incoming webhook in Slack
1. Set up your config file using config.sample as the basis
1. Deploy to parse
1. Set up the send_nags job to run every minute/however often you like

# Usage
Once up and running, trigger this bot with a command like:

```
/nag @username at 2pm on wed to do something
/nag #channel at 10:30am weekdays to do something else
```

# Develop

```bash
coffee -wco . src
parse develop nagbot
```

(Replace nagbot with whatever your parse application is named)
