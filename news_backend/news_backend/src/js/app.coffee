app = angular.module 'newsApp', [
    'ui.router',
    'ngRoute'
]
app.config [
    '$stateProvider',
    '$urlRouterProvider',
    ($stateProvider, $urlRouterProvider) ->
        $urlRouterProvider.otherwise '/'
        $stateProvider.state('main',
            url: '/'
            templateUrl: 'static/views/main.html'
            controller: 'MainCtrl'
        )
]
