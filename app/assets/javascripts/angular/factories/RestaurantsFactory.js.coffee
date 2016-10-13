@dininggradesApp.factory 'RestaurantsFactory', ($http) ->

  factory = {}
  api = '/api/v1/'

  factory.search = (params) ->
    $http.post api + 'search', params

  factory.getRestaurant = (factual_id) ->
    $http.get api + 'restaurant/' + factual_id

  factory.getQuestions = ->
    $http.get api + 'questions'

  factory.getTypeOfCuisine = ->
    $http.get api + 'cuisines'

  factory.getMyRatings = ->
    $http.get api + 'myratings'

  factory.getMyRestaurants = ->
    $http.get api + 'myrestaurants'

  factory.getRestaurantRatings = (id) ->
    $http.get api+ 'restaurant-ratings/' + id

  factory.submitRating = (params) ->
    $http.post api + 'submit-rating', params

  factory.suggestRestaurant = (params) ->
    $http.post api + 'suggest-restaurant', params

  factory.updateRestaurant = (params) ->
    $http.post api + 'update-restaurant', params    

  factory.claimRestaurant = (params) ->
    $http.post api + 'claim-restaurant', params

  factory.getMyAddress = ->
    $http.get api + 'get-client-address'

  factory.resetPassword = (params) ->
    $http.post 'reset-password', params

  factory.submitContact = (params) ->
    $http.post 'contact-submission', params

  factory.submitFoodPoisoningReport = (params) ->
    $http.post api + 'submit-food-poisoning-report', params

  factory