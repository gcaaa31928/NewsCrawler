app = angular.module 'newsApp', [
    'ui.router'
    'ngRoute'
    'infinite-scroll'
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
