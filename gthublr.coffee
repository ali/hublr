class Cache
  API_ROOT = '//api.github.com/repos/'

  constructor: ->
    @_storage = {}

  set: (slug, data, callback) =>
    console.log "Setting #{slug}"
    @_storage[slug] = data
    callback data  if callback?

  _fetch: (slug, callback) =>
    $.ajax({
      url: API_ROOT + slug
    }).done((data) =>
      console.log "Fetched #{slug}"
      @set slug, data, callback
    ).fail =>
      console.error "Failed to fetch #{slug}"
      @set slug, undefined, callback

  get: (slug, callback) =>
    if @_storage[slug]?
      console.log "Pulled #{slug} from the cache"
      callback @_storage[slug]
    else
      @_fetch slug, callback

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

