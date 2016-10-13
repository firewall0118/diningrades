@dininggradesApp.controller 'GoogleMapCtrl', ['$rootScope', '$scope', '$timeout', '$filter', 'Auth', 'RestaurantsFactory', 'usSpinnerService', ($rootScope, $scope, $timeout, $filter, Auth, RestaurantsFactory, usSpinnerService)  ->
  # map
  map = null
  geocoder = new google.maps.Geocoder()
  infoWindow = new google.maps.InfoWindow()
  $scope.$on 'mapInitialized', (evt, evtMap) ->
    map = evtMap

    $scope.mapClicked = (e) ->
      infoWindow.close()

  # Modals
  firsttimeModal = $('#firsttimeModal')
  gpsModal = $('#gpsModal')
  claimRestaurantModal = $('#claimRestaurantModal')
  claimMyModal = $('#claimMyModal')
  suggestRestaurantModal = $('#suggestRestaurantModal')

  # Left Sidebars
  searchBox = $('#search-box')
  searchResults = $('#searchResults')
  restaurantDetails = $('#restaurantDetails')
  ratingRestaurant = $('#ratingRestaurant')
  thankyou = $('#thankyou')
  reportRestaurant = $('#reportRestaurant')
  thankyouReport = $('#thankyouReport')
  
  leftSidebars = $('.lsidebar')

  # scope variables
  $scope.search_condition = {} # Restaurant Search Conditions
  $scope.questions = [] # restaurant rating questions
  $scope.restaurants = [] # restaurants by search
  $scope.locals = [] # restaurant data stored in the database
  $scope.predicate = "name"
  $scope.reverse = false
  $scope.restaurant = {} # selected restaurant
  $scope.more_options = false # Show restaurant more info
  $scope.rating_more_details = false # Show restaurant more details when rating
  $scope.comment = ""
  $scope.is_submit = false
  $scope.rating_submit_validate = true
  $scope.client_info = null
  $scope.myLatLng = null
  $scope.spinneractive = false
  $scope.suggest = # Suggest Restaurant
    category_ids: ''
    cuisine: []
    name: ''
    country: ''
    region: ''
    locality: ''
    address: ''
    address_extended: ''
    website: ''
    email: ''
    tel: ''
    postcode: ''
    hours_display: ''
    latitude: ''
    longitude: ''

  $scope.cuisines = [] # type of cuisine

  $scope.claim_info = # claim restaurant info
    first_name: ''
    last_name: ''
    email: ''
    tel: ''
    address: ''
    locality: ''
    region: ''
    zipcode: ''

  $scope.thankyou_info = {} # thank you page

  # rating controls
  rdSatisfaction = $('#rdSatisfaction').rateYo readOnly: true
  rdRecommendation = $('#rdRecommendation').rateYo readOnly: true
  ratingSatisfaction = $('#ratingSatisfaction').rateYo precision: 0
  ratingRecommendation = $('#ratingRecommendation').rateYo precision: 0

  # init values
  RestaurantsFactory.getQuestions($scope.restaurant.factual_id).then (resp) ->
    $scope.questions = JSON.parse(resp.data.questions)

  $scope.is_map_loading = true
  $scope.is_first_search = true;

  # gps functions
  $scope.allowGPSInfo = (allow) ->
    localStorage.setItem("gps", allow)
    gpsModal.modal('hide')
    if allow
      $scope.getMyAddress()
    else
      $scope.is_map_loading = false
      $scope.searchMapByBounds() # auto load restaurants for the first time page load

  $scope.getMyAddress = ->
    RestaurantsFactory.getMyAddress().then (resp) ->
      $scope.client_info = resp.data.info
      $scope.myLatLng = new google.maps.LatLng($scope.client_info.lat, $scope.client_info.lon)
      #$scope.myLatLng = new google.maps.LatLng(40.7033127,-73.979681)
      if map
        map.setCenter($scope.myLatLng)
        map.setZoom(12)
      else
        $timeout (->
          map.setCenter($scope.myLatLng)
          map.setZoom(12)
        ), 500

      $timeout (->
        $scope.is_map_loading = false
        $scope.searchMapByBounds() # auto load restaurants for the first time page load
      ), 500
      

  # map icon
  $scope.mapIcon = (r) ->
    color = $filter('gradescolor')(r.grades)
    icon = 
      path: 'M50,5C33.431,5,20,18.431,20,35c0,23,24,60,30,60s30-35.875,30-60C80,18.431,66.569,5,50,5z M50,50  c-8.284,0-15-6.716-15-15c0-8.284,6.716-15,15-15s15,6.716,15,15C65,43.284,58.284,50,50,50z'
      fillColor: color
      fillOpacity: 1
      strokeColor: color
      scale: 0.2
    icon

  # map info window
  $scope.openInfoWindow = (event, r) ->
    infoWindow.setContent("<div class='show-restaurant-profile' data-id='" + r.id + "'><strong>" + r.name + '</strong></div>' + r.address + ' ' + r.locality + ' ' + r.region + ' ' + r.postcode)
    marker = map.markers['marker' + r.id]
    infoWindow.open(map, marker)
    map.setCenter(marker.getPosition())
    # show restaurant details if map marker click
    $scope.viewProfile(r)

  # map dragend event
  $scope.mapDragend = ->
    unless $scope.is_map_loading
      console.log("map dragend")
      $scope.searchMapByBounds()

  # map zoom changed
  $scope.mapZoomChanged = ->
    unless $scope.is_map_loading
      console.log("map zoom changed")
      $scope.searchMapByBounds()

  # get type of cuisine
  $scope.$on 'type-of-cuisine', (event, args) ->
    $scope.cuisines = args

  # search map
  $scope.$on 'search-map', (event, args) ->
    $scope.search_condition = JSON.parse(args.search)

    if $scope.search_condition.address != ''
      geocoder.geocode {
        'address': $scope.search_condition.address #'10007' #'los angeles'
        'componentRestrictions': { 'country': 'US' }
      }, (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          console.log(results[0])
          g = results[0]
          # 625 km, 25 * 25
          lat_k = 0.008983
          lon_k = 0.015060
          map.setCenter(g.geometry.location)
          map.fitBounds g.geometry.bounds
        else
          console.log 'Geocode was not successful for the following reason: ' + status
        
        # $scope.searchMapByBounds() # this function called by mapZoomChanged or mapDragged
    else
      $scope.searchMapByBounds()

  $scope.searchMapByBounds = ->
    center = map.getCenter()
    bounds = map.getBounds()
    meters = distance(center.lat(), center.lng(), bounds.getNorthEast().lat(), bounds.getNorthEast().lng(), 'K') * 1000
    zoom = map.getZoom()

    $scope.search_condition.lat = center.lat()
    $scope.search_condition.lon = center.lng()
    $scope.search_condition.meters = meters
    $scope.search_condition.south_west_point_lat = bounds.getSouthWest().lat()
    $scope.search_condition.south_west_point_lon = bounds.getSouthWest().lng()
    $scope.search_condition.north_east_point_lat = bounds.getNorthEast().lat()
    $scope.search_condition.north_east_point_lon = bounds.getNorthEast().lat()

    #if zoom > 8
    RestaurantsFactory.search($scope.search_condition).then (resp) ->
      console.log(resp)
      resp.data.fitMap = false
      resp.data.search = JSON.stringify(angular.copy($scope.search_condition))
      $rootScope.$broadcast 'show-search-results', resp.data

      $scope.is_map_loading = false

  # show search results left side bar
  $scope.$on 'show-search-results', (event, args) ->
    $scope.search_condition = JSON.parse(args.search)
    $scope.restaurants = JSON.parse(args.restaurants)
    #$scope.restaurants = args.restaurants
    
    updateRestaurants()

    if not $scope.is_first_search
      $scope.showResults()
    else
      $scope.is_first_search = false

    # render rating controls
    $timeout (->
      searchResults.find(".rating-a").rateYo
        readOnly: true
        starWidth: "15px"
    ), 0

    #if args.fitMap and $scope.restaurants.length > 0
      # fit the map to includes all of points
      #bounds = new google.maps.LatLngBounds
      #i = 0
      #while i < $scope.restaurants.length
      #  pt = $scope.restaurants[i]
      #  pos = new google.maps.LatLng(pt.latitude, pt.longitude)
      #  bounds.extend pos
      #  i++
      # map.fitBounds bounds

  $scope.showMore = ->
    $scope.search_condition.offset += 100
    $scope.spinneractive = true
    usSpinnerService.spin('spinner-showmore')

    RestaurantsFactory.search($scope.search_condition).then (resp) ->
      $scope.spinneractive = false
      usSpinnerService.stop('spinner-showmore')

      rs = JSON.parse(resp.data.restaurants)
      $scope.restaurants = $scope.restaurants.concat(rs)
      updateRestaurants()

  updateRestaurants = ->
    $scope.restaurants.forEach (r) ->
      if $scope.myLatLng != null
        r.distance = distance(parseFloat(r.latitude), parseFloat(r.longitude), $scope.myLatLng.lat(), $scope.myLatLng.lng(), 'K') unless r.hasOwnProperty('distance')

      # update users, claim the restaurant
      r.user_restaurants = _.pluck(r.user_restaurants, 'user_id')

  $scope.order = (predicate) ->
    $scope.reverse = if $scope.predicate == predicate then !$scope.reverse else false
    $scope.predicate = predicate
    return

  $scope.showResults = ->
    slideShowSidebar(searchResults)

  $scope.showFoodSatefyCourseBanner = ->
    if $scope.restaurant.user_restaurants and Auth._currentUser
      $scope.restaurant.user_restaurants.indexOf(Auth._currentUser.id) != -1
    else
      false

  # view restaurant Details
  $scope.viewProfile = (data) ->
    $scope.restaurant = data
    $scope.more_options = false
    $timeout (->
      rdSatisfaction.rateYo 'rating', parseFloat($scope.restaurant.satisfaction)
      rdRecommendation.rateYo 'rating', parseFloat($scope.restaurant.recommendation)

      restaurantDetails.find(".comment .rating-a").rateYo
        readOnly: true
        starWidth: "15px"
    ), 0

    slideShowSidebar(restaurantDetails)

  $scope.viewRate = (data) ->
    $scope.restaurant = data if data

    $scope.rating_submit_validate = true
    $scope.rating_more_details = false

    ratingSatisfaction.rateYo 'rating', 0
    ratingRecommendation.rateYo 'rating', 0
    slideShowSidebar(ratingRestaurant)

  $scope.submitRating = ->
    temp_res = jQuery.extend({}, $scope.restaurant)

    if Auth.isAuthenticated()
      sat_val = ratingSatisfaction.rateYo('rating')
      rec_val = ratingRecommendation.rateYo('rating')

      if sat_val is 0 or rec_val is 0
        $scope.rating_submit_validate = false
        return

      params = 
        factual_id: $scope.restaurant.factual_id
        satisfaction: sat_val
        recommendation: rec_val
        comment: $scope.comment

      $scope.questions.forEach (q) ->
        if q.options.length > 0
          params["question" + q.id] = $('input[name=rdo_questions' + q.id + ']:checked').val()
          if params["question" + q.id] is '' and q.extended is false
            $scope.rating_submit_validate = false
            return
      
      RestaurantsFactory.submitRating(params).then (resp) ->
        if resp.data.success
          $scope.thankyou_info =
            name: $scope.restaurant.name
            grades: resp.data.grades
            
          slideShowSidebar(thankyou)
    else
      $scope.is_submit = true
      $rootScope.$broadcast 'login-popup', 'submit-rating'

  $scope.$on 'submit-rating', (event, args) ->
    $scope.submitRating() if $scope.is_submit

  $scope.findNewRestaurant = ->
    slideShowSidebar(null)

  $scope.claimThisListing = ->
    showModal(claimRestaurantModal)

  $scope.claimRestaurantListing = ->
    $scope.claim_info =
      restaurant_id: $scope.restaurant.id
      first_name: ''
      last_name: ''
      email: ''
      tel: ''
      address: ''
      locality: ''
      region: ''
      zipcode: ''

    claimRestaurantModal.modal('hide')
    if Auth.isAuthenticated()
      $scope.claim_info.first_name = Auth._currentUser.name
      $scope.claim_info.email = Auth._currentUser.email
      showModal(claimMyModal)
    else
      $scope.is_submit = true
      $rootScope.$broadcast 'login-popup', 'claim-restaurnat'

  $scope.$on 'claim-restaurnat', (event, args) ->
    $scope.claim_info.email = Auth.currentUser().email
    showModal(claimMyModal)

  $scope.submitClaimRestaurant = (e) ->
    RestaurantsFactory.claimRestaurant($scope.claim_info).then (resp) ->
      claimMyModal.modal('hide')
      $rootScope.$broadcast 'show-notice', 'The site administrater will review your claim.'

    e.preventDefault()
    false

  $scope.openSuggestRestaurant = ->
    showModal(suggestRestaurantModal)

  $scope.submitSuggestRestaurant = (e) ->
    RestaurantsFactory.suggestRestaurant($scope.suggest).then (resp) ->
      $scope.suggest =
        category_ids: ''
        cuisine: []
        name: ''
        country: ''
        region: ''
        locality: ''
        address: ''
        address_extended: ''
        website: ''
        email: ''
        tel: ''
        postcode: ''
        hours_display: ''
        latitude: ''
        longitude: ''
      suggestRestaurantModal.modal('hide')
      $rootScope.$broadcast 'show-notice', 'Thank you for suggesting a restaurant'

    e.preventDefault()
    false

  $scope.openFoodPoisoningReport = ->
    $scope.food_report = 
      restaurant_id: $scope.restaurant.id
      comment: ''
      fever: 0
      nausea: 0
      vomiting: 0
      diarrhea: 0
      abdominal_pain: 0
      headache: 0
      chest_pain: 0
      numbness_tingling: 0
      dizziness: 0
      rash: 0
      date_of_exposure: ''
      suspected_food_time: ''
      healthcare_provider: 0
      provider_email: ''
      patient_name: ''
      patient_telephone: ''
      patient_antibiotic: 0
      facility_name: ''
      facility_phone: ''
      send_to_restaurant: 0
      
    slideShowSidebar(reportRestaurant)

  $scope.submitFoodPoisoningReport = (e) ->
    $scope.food_report.date_of_exposure = reportRestaurant.find('.bt-date-picker').val()
    $scope.food_report.suspected_food_time = reportRestaurant.find('.bt-time-picker').val()
    RestaurantsFactory.submitFoodPoisoningReport($scope.food_report).then (resp) ->
      slideShowSidebar(thankyouReport)

    e.preventDefault()
    false

  $scope.backRestaurant = ->
    slideShowSidebar(restaurantDetails)

  slideShowSidebar = (bar) ->
    $scope.is_submit = false
    if !bar.is(":visible")
      leftSidebars.hide()
      bar.show 'slide', { direction: 'left' }, 100 if bar
    return

  showModal = (popModal) ->
    $timeout (->
      popModal.modal
        show: true
        backdrop: 'static'
        keyboard: false
    ), 500
    return

  # distance between 2 positions
  distance = (lat1, lon1, lat2, lon2, unit) ->
    radlat1 = Math.PI * lat1 / 180
    radlat2 = Math.PI * lat2 / 180
    radlon1 = Math.PI * lon1 / 180
    radlon2 = Math.PI * lon2 / 180
    theta = lon1 - lon2
    radtheta = Math.PI * theta / 180
    dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta)
    dist = Math.acos(dist)
    dist = dist * 180 / Math.PI
    dist = dist * 60 * 1.1515
    if unit == 'K'
      dist = dist * 1.609344
    if unit == 'N'
      dist = dist * 0.8684
    dist

  # show firsttime modal box
  firsttime = localStorage.getItem("visit")
  gps = localStorage.getItem("gps")
  if not firsttime
    searchBox.hide()
    firsttimeModal.modal
      show: true
      backdrop: 'static'
      keyboard: false
  else
    myInterval = setInterval((->
      if map != null
        clearInterval(myInterval)
        if gps == "true"
          $scope.getMyAddress()
        else
          $scope.searchMapByBounds() # auto load restaurants for the first time page load
    ), 1000)

  firsttimeModal.find('.btn-default').click ->
    localStorage.setItem("visit", "yes")
    firsttimeModal.modal('hide')
    gpsModal.modal
      show: true
      backdrop: 'static'
      keyboard: false
    searchBox.show()
]