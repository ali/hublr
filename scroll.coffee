$('.pagination.ajax_paginate').hide()

copyright = $('.site-footer-links:not(.right)').children().first()
copyright.addClass('copyright')

linksLeft = $('.site-footer-links:not(.right)').children().not('.copyright')
linksRight = $('.site-footer-links.right').children()
links = new Array(linksLeft, "\n", linksRight)

$('.site-footer-links').children().not('.copyright').css({'display':'inline', 'padding-right':'10px'})

$('.dashboard-sidebar').append(copyright, links)
$('.dashboard-sidebar').children('li').css({'list-style-type':'none'})

$(window).scroll ->
  if ($(window).scrollTop() + $(window).height()) > ($(document).height() - 400)
    $('.js-events-pagination')[0].click()
    $('.pagination.ajax_paginate').hide()
