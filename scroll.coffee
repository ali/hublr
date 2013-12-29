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

# Endless scrolling
$(window).scroll ->
  if ($(window).scrollTop() + $(window).height()) > ($(document).height() - 400)
    $('a.js-events-pagination').click()
    $('.pagination.ajax_paginate').hide()
