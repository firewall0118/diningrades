$ ->
  $('#search-box .fa-angle-double-down').click ->
    $('#search-box .fa, #search-box dd').toggle()

  $('#search-box .fa-angle-double-up').click ->
    $('#search-box .fa, #search-box dd').toggle()

  $('footer .show-footer-arrow').click ->
    $('footer .container').slideDown()
    $('footer .footer-menu').hide()

  $('footer .svg-down-long-arrow').click ->
    $('footer .container').slideUp()
    $('footer .footer-menu').show()