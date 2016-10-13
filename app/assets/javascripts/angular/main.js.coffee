#= require_self
#= require_tree .

@dininggradesApp = angular.module('dininggradesApp', ['ngMap', 'Devise', 'angularSpinner', 'ui.multiselect'])

# Grades Label filter
.filter 'gradeslabel', ->
  (input) ->
    if input < 1
      'U' # Undefined
    else if input < 65
      'F'
    else if input < 75
      'D'
    else if input < 85
      'C'
    else if input < 96
      'B'
    else if input < 101
      'A'
    else
      'U' # Undefined
# Grades Color filter
.filter 'gradescolor', ->
  (input) ->
    if input < 65
      '#000000'
    else if input < 75
      '#3700d6'
    else if input < 85
      '#dd0000'
    else if input < 96
      '#e0e200'
    else if input < 101
      '#00c800'
    else
      '#aaaaaa'
# enter key directive
.directive 'ngEnter', ->
  (scope, element, attrs) ->
    element.bind 'keydown keypress', (event) ->
      if event.which == 13
        scope.$apply ->
          scope.$eval attrs.ngEnter, 'event': event
          return
        event.preventDefault()