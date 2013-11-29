stars = $('.alert.watch_started .simple')
API_ROOT = 'https://api.github.com/repos/'

for repo in stars
  repoName = $(repo).find('.title a:nth-child(3)').text()
  do (repo) ->
    $.ajax(
      url: API_ROOT + repoName
    ).done (response) ->
      $description = $("<div>#{ response.description }</div>")
      $(repo).append $description