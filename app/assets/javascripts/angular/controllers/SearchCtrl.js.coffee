@dininggradesApp.controller 'SearchCtrl', ['$rootScope', '$scope', 'RestaurantsFactory', ($rootScope, $scope, RestaurantsFactory)  ->

  $scope.search = 
    offset: 0 # offset of search query
    address: ''
    cuisine: ''
    cuisinelabel: ''
    grade: ''
    gradelabel: ''

  $scope.cuisines = []

  $scope.grades = [
    {
      label: 'ALL'
      value: '0,100'
    }
    {
      label: 'A'
      value: '96,100'
    }
    {
      label: 'B'
      value: '85,100'
    }
    {
      label: 'C'
      value: '75,100'
    }
    {
      label: 'D'
      value: '65,100'
    }
    {
      label: 'F'
      value: '1,100'
    }
    {
      label: 'U'
      value: '0,0'
    }
  ]

  controller = $('#search-box').data('controller')

  RestaurantsFactory.getTypeOfCuisine().then (resp) ->
    $scope.cuisines = resp.data.cuisines
    $rootScope.$broadcast 'type-of-cuisine', angular.copy(resp.data.cuisines)
    $scope.cuisines.unshift { label: 'Select', value: '' }
  
  $scope.searchRestaurants = ->
    if controller is 'visitors'
      w = $(window).width()
      # RestaurantsFactory.search($scope.search).then (resp) ->
      #   resp.data.fitMap = true
      #   resp.data.search = JSON.stringify(angular.copy($scope.search))
      #   $rootScope.$broadcast 'show-search-results', resp.data
      #   $('#search-box dd').hide() if w < 768

      data =
        fitMap: true
        search: JSON.stringify(angular.copy($scope.search))
      $rootScope.$broadcast 'search-map', data

      $('#search-box dd').hide() if w < 768
    else
      json = JSON.stringify(angular.copy($scope.search))
      localStorage.setItem('search', json)
      location.href = '/'

  # check the search parameters
  json = localStorage.getItem('search')
  if json != '' and json != null
    json = JSON.parse(json)
    $scope.search = angular.copy(json)
    localStorage.setItem('search', '')
    $scope.searchRestaurants()

]         