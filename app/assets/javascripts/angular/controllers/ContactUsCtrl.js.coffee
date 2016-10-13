@dininggradesApp.controller 'ContactUsCtrl', ['$rootScope', '$scope', '$timeout', '$window', 'RestaurantsFactory', 'Auth', ($rootScope, $scope, $timeout, $window, RestaurantsFactory, Auth)  ->

  $scope.contact = 
    firstname: ''
    lastname: ''
    email: ''
    phone: ''
    message: ''

  $scope.submitted = false

  $scope.submitContact = (e) ->
    RestaurantsFactory.submitContact($scope.contact).then (resp) ->
      $scope.submitted = true
      $scope.contact = 
        firstname: ''
        lastname: ''
        email: ''
        phone: ''
        message: ''

    e.preventDefault()
    false

  return
]