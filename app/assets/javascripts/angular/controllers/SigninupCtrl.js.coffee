@dininggradesApp.controller 'SigninupCtrl', ['$rootScope', '$scope', '$timeout', 'Auth', 'RestaurantsFactory', ($rootScope, $scope, $timeout, Auth, RestaurantsFactory)  ->

  # modals
  loginModal = $('#loginModal')
  signupModal = $('#signupModal')
  updateModal = $('#updateModal')
  passwordModal = $('#passwordModal')
  forgetPwdModal = $('#forgetPwdModal')
  noticeModal = $('#noticeModal')

  modals = $('.signinup-modal')

  $scope.loginError = ''
  $scope.loginForm =
    email: ''
    password: ''

  $scope.registerErrors = ''
  $scope.registrationForm = 
    name: ''
    zipcode: ''
    email: ''
    password: ''
    password_confirmation: ''

  $scope.updateErrors = ''
  $scope.passwordErrors = ''

  $scope.resetEmail = ''
  $scope.resetEmailError = ''

  $scope.user = null
  $scope.tuser = null

  $scope.notice = ''

  $scope.afterLogin = ''

  $scope.$on 'login-popup', (event, args) ->
    $scope.afterLogin = args
    $scope.showLogin()

  $scope.$on 'signup-popup', (event, args) ->
    $scope.afterLogin = ''
    $scope.showSignup()

  $scope.$on 'logout-popup', (event, args) ->
    $scope.submitLogoutForm()

  $scope.$on 'update-popup', (event, args) ->
    showModal(updateModal)

  $scope.$on 'password-popup', (event, args) ->
    $scope.tuser = angular.copy($scope.user)
    $scope.tuser.password = ''
    $scope.tuser.password_confirmation = ''
    $scope.tuser.current_password = ''
    showModal(passwordModal)

  $scope.showLogin = ->
    showModal(loginModal)

  $scope.showSignup = ->
    showModal(signupModal)

  showModal = (popModal) ->
    modals.modal('hide')
    
    $timeout (->
      popModal.modal
        show: true
        backdrop: 'static'
        keyboard: false
    ), 500

    return

  $scope.submitLoginForm = ->
    $scope.loginError = ""
    Auth.login($scope.loginForm).then ((user) ->
      updateTopNav()
      loginModal.modal('hide')
      $rootScope.$broadcast $scope.afterLogin unless $scope.afterLogin == ''
    ), (error) ->
      $scope.loginError = error.data.error
      console.log error

  $scope.submitRegistrationForm = ->
    $scope.registerErrors = ''
    Auth.register($scope.registrationForm).then ((registeredUser) ->
      updateTopNav()
      signupModal.modal('hide')
      $rootScope.$broadcast $scope.afterLogin unless $scope.afterLogin == ''
    ), (error) ->
      $scope.registerErrors = error.data.errors
      console.log error

  $scope.submitLogoutForm = ->
    Auth.logout().then ((oldUser) ->
      updateTopNav()
      location.href = "/"
    ), (error) ->
      console.log error

  $scope.updateAccount = ->
    $scope.updateErrors = ''
    Auth.update($scope.user).then ((updatedUser) ->
      updateModal.modal('hide')
      $rootScope.$broadcast 'show-account', $scope.user
    ), (error) ->
      $scope.updateErrors = error

  $scope.updatePassword = ->
    $scope.passwordErrors = ''
    if $scope.tuser.current_password != '' && $scope.tuser.password != '' && $scope.tuser.password_confirmation != ''
      Auth.update($scope.tuser).then ((updatedUser) ->
        passwordModal.modal('hide')
      ), (errorResp) ->
        if errorResp.data.errors.hasOwnProperty('current_password')
          $scope.passwordErrors = 'Current Password is invalid.'
        else
          $scope.passwordErrors = 'Password does not match'
    else
      $scope.passwordErrors = "Password can't be blank."

  $scope.showForgetPwdModal = ->
    loginModal.modal('hide')

    $scope.resetEmail = ''
    $scope.resetEmailError = ''
    showModal(forgetPwdModal)

  $scope.sendResetPwdEmail = ->
    $scope.resetEmailError = ''
    if $scope.resetEmail is ''
      $scope.resetEmailError = 'Email is blank'
    else
      params = 
        email: $scope.resetEmail
      RestaurantsFactory.resetPassword(params).then (resp) ->
        if resp.data.success
          forgetPwdModal.modal('hide')
          showNotice 'Sent you email with reset password instructions'
        else
          $scope.resetEmailError = 'Email does not exists'

  $scope.$on 'show-notice', (event, args) ->
    showNotice(args)

  showNotice = (notice) ->
    $scope.notice = notice
    showModal(noticeModal)
    $timeout (->
      noticeModal.modal('hide')
    ), 5000

  updateTopNav = ->
    $("ul.navbar-nav li").hide()
    
    Auth.currentUser().then ((user) ->
      $scope.user = user
      $rootScope.$broadcast 'show-account', user

      $("ul.navbar-nav li.logout").show()
      # admin user
      if user.role_id is 3
        $("ul.navbar-nav li.logout-admin").show()
        
    ), (error) ->
      $("ul.navbar-nav li.login").show()

  updateTopNav()
]