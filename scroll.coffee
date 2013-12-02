$('.pagination.ajax_paginate').hide()

$(window).scroll ->
  if ($(window).scrollTop() + $(window).height()) > ($(document).height() - 200)
    $('.js-events-pagination').click()
    $('.pagination.ajax_paginate').hide()
