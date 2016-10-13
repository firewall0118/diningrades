$ ->
  # render date and time controls
  $('.bt-date-picker').datetimepicker
    format: 'YYYY-MM-DD'
    widgetPositioning:
      horizontal: 'right'
      vertical: 'auto'    
      
  $('.bt-time-picker').datetimepicker
    format: 'LT'
    widgetPositioning:
      horizontal: 'right'
      vertical: 'auto'

  # Hide Left hand Sidebar
  $('.lsidebar .close-left-sidebar').click ->
    $('.lsidebar').hide 'slide', { direction: 'left' }, 300

  # open new window
  $(document).on 'click', '.open-window', ->
    window.open($(this).data('link'),'window','width=640,height=480,resizable,scrollbars,toolbar,menubar') 

  # close nav bar for iphone view when click outside of menu
  $(document).click (event) ->
    clickover = $(event.target)
    _opened = $('.navbar-collapse').hasClass('in')
    if _opened == true and !clickover.hasClass('navbar-toggle')
      $('button.navbar-toggle').click()
    return