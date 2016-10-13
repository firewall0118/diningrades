@dininggradesApp.controller 'TopNavCtrl', ['$rootScope', '$scope', ($rootScope, $scope)  ->

  $scope.login = ->
    $rootScope.$broadcast 'login-popup'

  $scope.signup = ->
    $rootScope.$broadcast 'signup-popup'

  $scope.logout = ->
    $rootScope.$broadcast 'logout-popup'
]