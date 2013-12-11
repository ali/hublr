$('.pagination.ajax_paginate').hide()
for link in $('.site-footer-links')
  $('.dashboard-sidebar').append (link)

$(window).scroll ->
  if ($(window).scrollTop() + $(window).height()) > ($(document).height() - 400)
    $('.js-events-pagination')[0].click()
    $('.pagination.ajax_paginate').hide()
