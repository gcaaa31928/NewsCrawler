angular.module('newsApp').factory 'Configuration', [
    ($http, $q) ->
        factory = {}
        factory.server_end_point = 'http://localhost:8000'
        factory
]