class Cache
  API_ROOT = '//api.github.com/repos/'

  constructor: ->
    @_storage = chrome.storage.local
    @fails = {}
    @sweep()

  set: (slug, data, callback) ->
    # This is hacky. Coffeescript made me do it.
    items = {}
    items[slug] = data
    @_storage.set items, ->
      do (slug, data, callback) ->
        callback data if callback?

  _fetch: (slug, callback) =>
    return if @fails[slug]

    $.ajax({
      url: API_ROOT + slug
    }).done((data) =>
      console.log "Fetched #{ slug }"
      data.hublr = Date.now()
      @set slug, data, callback
    ).fail (err) =>
      console.error "Failed to fetch #{ slug }"
      @fails[slug] = Date.now()

  get: (slug, callback) =>
    @_storage.get slug, (items) =>
      data = items[slug]
      if data?.hublr # Check if the data was actually set
        console.log "Pulled #{ slug } from the cache"
        callback data
      else
        @_fetch slug, callback

  sweep: ->
    @_storage.get null, (items) =>
      console.log 'Sweeping the cache...'
      slugs = (slug for slug, data of items when Object.keys(data).length < 5)
      @_storage.remove slugs

addDescription = ($repo, description) ->
  $description = $("<div class='message hublr-description'>)")
  $description.append $("<p>#{ description }</p>")
  $repo.append $description
  $repo

addMeta = ($repo, watchers, stars, forks) ->
  makeSpan = (n, icon) ->
    $("<span> #{ n.toLocaleString() }<span class='octicon #{ icon }'>")

  $meta = $("<div class='hublr-meta'>")
  $meta.append(makeSpan watchers, 'octicon-eye-watch')
  $meta.append(makeSpan stars, 'octicon-star')
  $meta.append(makeSpan forks, 'octicon-git-branch-create')
  $repo.prepend $meta
  $repo

hublrfy = ($repo) ->
  repoURL = $repo.find('.title a:last-child').attr 'href'
  slug = repoURL.match(/.*\/(\S+\/\S+?)\/?$/)[1]

  cache.get slug, (data) ->
    if data?.hublr
      if data.description
        addDescription $repo, data.description

      if data.subscribers_count? and data.watchers? and data.forks?
        addMeta $repo, data.subscribers_count, data.watchers, data.forks

  $repo.addClass 'hublr'
  $repo

findRepos = ->
  types = ['fork', 'create', 'watch_started']
  selectors = (".alert.simple.#{type} .simple:not(.hublr)" for type in types)
  $(selectors.join ', ')

cache = new Cache()

bangarang = (retry=0) ->
  repos = findRepos()

  if repos.length is 0
    console.error "Couldn't find any repos. Rebanging..."
    if retry < 5
      setTimeout bangarang, 200, retry + 1
    else
      setTimeout bangarang, 1000, retry/2

    return

  for repo in findRepos()
    do (repo) ->
      hublrfy $(repo)

  $('.js-events-pagination').click ->
    setTimeout bangarang, 250

  repos

bangarang()
