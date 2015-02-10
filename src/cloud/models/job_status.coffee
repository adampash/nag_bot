ParseFinder = require 'cloud/mixins/finder'

module.exports = JobStatus = ParseFinder.extend "JobStatus",
  foo: 'bar'
,
  # class methods
  findOrCreate: ->
    @findBy({}).then (status) =>
      unless status?
        status = new @(last_run_at: new Date())
      return status.save()
