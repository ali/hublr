stars = $('.alert.watch_started .simple')
API_ROOT = 'https://api.github.com/repos/'

for repo in stars
  do (repo) ->
    repoName = $(repo).find('.title a:nth-child(3)').text()
    $.ajax(
      url: API_ROOT + repoName
    ).done (response) ->
      $description = $("<div class='message gthublr-description'>")
      $description.text response.description
      $(repo).append $description
