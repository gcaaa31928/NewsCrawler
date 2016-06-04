angular.module('newsApp').controller('MainCtrl', [
    '$scope',
    'TaiwanService'
    ($scope, TaiwanService) ->
        setTimeout(() ->
            TaiwanService.d3_render_ping(25.060843, 121.544125);
        , 1000)
])