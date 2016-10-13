@dininggradesApp.controller 'AccountCtrl', ['$rootScope', '$scope', '$timeout', '$window', 'RestaurantsFactory', 'Auth', ($rootScope, $scope, $timeout, $window, RestaurantsFactory, Auth)  ->

  $scope.ratings = []
  $scope.myrestaurants = []
  $scope.selectedRestaurantIndex = {}
  $scope.restaurantInfo = {}
  $scope.restaurantRatings = []
  pastRatings = $("#past-ratings")
  myRestaurants = $("#my-restaurants")

  $scope.cuisines = [] # type of cuisine

  # Modals
  restaurantInfoModal = $('#restaurantInfoModal')
  restaurantRatingsModal = $('#restaurantRatingsModal')
  
  RestaurantsFactory.getMyRatings().then (resp) ->
    $scope.ratings = JSON.parse(resp.data.ratings) if resp.data.success
    $timeout (->
      pastRatings.find(".rating").rateYo readOnly: true
    ), 0

  RestaurantsFactory.getMyRestaurants().then (resp) ->
    $scope.myrestaurants = JSON.parse(resp.data.myrestaurants) if resp.data.success
    $timeout (->
      myRestaurants.find(".rating").rateYo readOnly: true
    ), 0

  $scope.predicate = "restaurant.name"
  $scope.reverse = false
  $scope.order = (predicate) ->
    $scope.reverse = if $scope.predicate == predicate then !$scope.reverse else false
    $scope.predicate = predicate
    return

  $scope.$on 'show-account', (event, args) ->
    $scope.current_user = angular.copy(args)

  # get type of cuisine
  $scope.$on 'type-of-cuisine', (event, args) ->
    $scope.cuisines = args

  $scope.updateUser = () ->
    $rootScope.$broadcast 'update-popup'

  $scope.updatePassword = () ->
    $rootScope.$broadcast 'password-popup'

  $scope.showRestaurantInfo = (restaurant, idx) ->
    $scope.selectedRestaurantIndex = idx
    $scope.restaurantInfo = resetRestaurantInfo(restaurant)
    showModal(restaurantInfoModal)

  $scope.editRestaurant = (e) ->
    RestaurantsFactory.updateRestaurant($scope.restaurantInfo).then (resp) ->
      $scope.myrestaurants[$scope.selectedRestaurantIndex].restaurant = resp.data.restaurant
      restaurantInfoModal.modal('hide')

    e.preventDefault()
    false

  $scope.showRestaurantRatings = (restaurant) ->
    $scope.restaurantInfo = resetRestaurantInfo(restaurant)
    RestaurantsFactory.getRestaurantRatings($scope.restaurantInfo.id).then (resp) ->
      $scope.restaurantRatings = JSON.parse(resp.data.ratings)
      showModal(restaurantRatingsModal)
      $timeout (->
        restaurantRatingsModal.find(".rating").rateYo readOnly: true
      ), 0

  # reset values
  resetRestaurantInfo = (restaurant) ->
    temp = angular.copy(restaurant)
    temp.latitude = parseFloat(temp.latitude)
    temp.longitude = parseFloat(temp.longitude)
    t_cuisines = temp.cuisine.split(', ')
    t_cids = temp.category_ids.split(', ')
    cuisine = []
    i = 0
    while i < t_cuisines.length
      cuisine.push
        label: t_cuisines[i]
        value: t_cids[i].substring(1, t_cids[i].length - 1)
      i++
    temp.cuisine = cuisine
    temp

  showModal = (popModal) ->
    $timeout (->
      popModal.modal
        show: true
        backdrop: 'static'
        keyboard: false
    ), 500
    return

]