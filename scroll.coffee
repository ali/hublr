$('.pagination.ajax_paginate').hide()

$(window).scroll ->
  if ($(window).scrollTop() + $(window).height()) > ($(document).height() - 200)
    $('.js-events-pagination')[0].click()
    $('.pagination.ajax_paginate').hide()
