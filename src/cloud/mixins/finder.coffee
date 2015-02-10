module.exports = ParseFinder = Parse.Object.extend "ParseFinder",
  foo: 'bar'

,
  # class methods
  find: (id, includes=[]) ->
    query = new Parse.Query(@)
    if includes.length
      for model in includes
        query.include(model)
    query.get id

  findBy: (options) ->
    query = @build(options)
    query.first()

  quickFind: (id) ->
    query = new Parse.Query(@)
    query.get id

  findAllEach: (options) ->
    @build(options)

  findAll: (options) ->
    query = @build(options)
    query.find()

  build: (options) ->
    query = new Parse.Query(@)
    if options.limit?
      query.limit(options.limit)
      delete options.limit
    if options.ascending?
      query.ascending(options.ascending)
      delete options.ascending
    if options.descending?
      query.descending(options.descending)
      delete options.descending
    if options.include?
      for model in options.include
        query.include(model)
      delete options.include
    if options.exists
      query.exists options.exists
      delete options.exists
    if options.doesNotExist
      query.doesNotExist options.doesNotExist
      delete options.doesNotExist
    if options.greaterThan
      for key, value of options.greaterThan
        query.greaterThan key, value
      delete options.greaterThan
    if options.lessThan
      for key, value of options.lessThan
        query.lessThan key, value
      delete options.lessThan
    if options.lessThanOrEqualTo
      for key, value of options.lessThanOrEqualTo
        query.lessThanOrEqualTo key, value
      delete options.lessThanOrEqualTo
    if options.containsAll
      for key, value of options.containsAll
        query.containsAll key, value
      delete options.containsAll
    for key, value of options
      query.equalTo key, value
    query
