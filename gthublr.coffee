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
      data.hublr = Date.now()
      @set slug, data, callback
    ).fail =>
      console.error "Failed to fetch #{slug}"
      @set slug, {}, callback

  get: (slug, callback) =>
    @_storage.get slug, (items) =>
      data = items[slug]
      if data?.hublr # Check if the data was actually set
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

addDescription = ($repo, description) ->
  $description = $("<div class='message hublr-description'>
    <p>#{description}</p>
  </div>")
  $repo.append $description
  $repo

addMeta = ($repo, stars, watchers, forks) ->
  $meta = $("<div class='hublr-meta'>
    <span>#{watchers}
    <span class='octicon octicon-eye-watch'></span>
    </span>
    <span>#{stars}
    <span class='octicon octicon-star'></span>
    </span>
    <span>#{forks}
    <span class='octicon octicon-git-branch-create'></span>
    </span>
    </div>")

  $repo.prepend $meta


for repo in repos
  $repo = $(repo)
  do ($repo) ->
    repoURL = $repo.find('.title a:nth-child(3)').attr 'href'
    slug = repoURL.match(/.*\/(\S+\/\S+?)\/?$/)[1]

    cache.get slug, (data) ->
      if data?.hublr
        if data.description
          addDescription $repo, data.description

        addMeta $repo, data.stargazers_count, data.watchers_count, data.forks
