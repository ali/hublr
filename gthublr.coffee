class Cache
  API_ROOT = '//api.github.com/repos/'

  constructor: ->
    @_storage = chrome.storage.local

  set: (slug, data, callback) ->
    # This is hacky. Coffeescript made me do it.
    items = {}
    items[slug] = data
    @_storage.set items, ->
      do (slug, data, callback) ->
        console.log "Cached #{slug}"
        callback data if callback?

  _fetch: (slug, callback) =>
    $.ajax({
      url: API_ROOT + slug
    }).done((data) =>
      console.log "Fetched #{slug}"
      data.hblr = Date.now()
      @set slug, data, callback
    ).fail =>
      console.error "Failed to fetch #{slug}"
      @set slug, {}, callback

  get: (slug, callback) =>
    @_storage.get slug, (items) =>
      data = items[slug]
      if data?.hblr # Check if the data was actually set
        console.log "Pulled #{slug} from the cache"
        callback data
      else
        @_fetch slug, callback

  clear: ->
    @_storage.clear()

cache = new Cache()

stars = $('.alert.watch_started .simple')
creates = $('.alert.create .simple')
repos = $.merge stars, creates

for repo in repos
  do (repo) ->
    repoURL = $(repo).find('.title a:nth-child(3)').attr 'href'
    slug = repoURL.match(/.*\/(\S+\/\S+?)\/?$/)[1]

    cache.get slug, (data) ->
      if data?.description
        $description = $("<div class='message gthublr-description'>")
        $description.text data.description
        $(repo).append $description

