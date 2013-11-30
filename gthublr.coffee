API_ROOT = '//api.github.com/repos/'

stars = $('.alert.watch_started .simple')
creates = $('.alert.create .simple')
repos = $.merge stars, creates

for repo in repos
  do (repo) ->
    repoURL = $(repo).find('.title a:nth-child(3)').attr 'href'
    slug = repoURL.match(/.*\/(\S+\/\S+?)\/?$/)[1]

    $.ajax({
      url: API_ROOT + slug
    }).done (response) ->
      if response.description
        $description = $("<div class='message gthublr-description'>")
        $description.text response.description
        $(repo).append $description
