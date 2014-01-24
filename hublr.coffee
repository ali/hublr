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

class Plugin
  load: -> console.error

class NewsFeedPlusPlus extends Plugin
  constructor: ->
    @_cache = new Cache()

  _findRepos: ->
    types = ['fork', 'create', 'watch_started']
    selectors = (".alert.simple.#{type} .simple:not(.hublr)" for type in types)
    $.find selectors.join(', ')

  _addDescription: ($repo, description) ->
    $description = $("<div class='message hublr-description'>")
    $description.append $("<p>#{ description }</p>")
    $repo.append $description
    $repo

  _addMeta: ($repo, watchers, stars, forks) ->
    makeSpan = (n, icon) ->
      $("<span> #{ n.toLocaleString() }<span class='octicon #{ icon }'>")

    $meta = $("<div class='hublr-meta'>")
    $meta.append makeSpan(watchers, 'octicon-eye-watch'),
      makeSpan(stars, 'octicon-star'),
      makeSpan(forks, 'octicon-git-branch-create')
    $repo.prepend $meta
    $repo

  _hublrize: ($repo) ->
    repoURL = $repo.find('.title a:last-child').attr 'href'
    slug = repoURL.match(/.*\/(\S+\/\S+?)\/?$/)[1]

    @_cache.get slug, (data) =>
      if data?.hublr
        if data.description
          @_addDescription $repo, data.description

        if data.subscribers_count? and data.watchers? and data.forks?
          @_addMeta $repo, data.subscribers_count, data.watchers, data.forks

    $repo.addClass 'hublr'
    $repo

  _processRepos: (repos) ->
    for repo in repos
      do (repo) => @_hublrize $(repo)

  load: ->
    @_processRepos @_findRepos()

    observer = new WebKitMutationObserver (mutations) =>
      # todo: only process added nodes
      @_processRepos @_findRepos()

    observer.observe $('#dashboard .news').get(0), { childList: true }

class InfiniteScroll extends Plugin
  load: ->
    # Hide pagination controls
    $('.pagination.ajax_paginate').hide()

    # Grab interesting DOM elements
    $sidebar = $('.dashboard-sidebar')
    $footerItems = $('.site-footer-links li')
    $copyright = $footerItems.find('> :not(a)').parent()

    # Create our new footer
    $footer = $('<div class="hublr-footer">')
    $footer.append $('<ul class="hublr-footer-links">').append($footerItems)
    $footer.append $('<p>').html($copyright.detach().html())

    # Add our footer to the sidebar
    $sidebar.append $footer

    # Watch for scrolling
    $(window).scroll ->
      if $(window).scrollTop() + $(window).height() > $(document).height() - 400
        $('.js-events-pagination')[0].click()
        $('.pagination.ajax_paginate').hide()

class Hublr
  constructor: ->
    console.log """
                oooo                     .o8       oooo
                `888                    "888       `888
                 888 .oo.   oooo  oooo   888oooo.   888  oooo d8b
                 888P"Y88b  `888  `888   d88' `88b  888  `888""8P
                 888   888   888   888   888   888  888   888
                 888   888   888   888   888   888  888   888
                o888o o888o  `V88V"V8P'  `Y8bod8P' o888o d888b
                """

    @plugins = [
      new NewsFeedPlusPlus()
      new InfiniteScroll()
    ]
    plugin.load() for plugin in @plugins

$ -> new Hublr()
