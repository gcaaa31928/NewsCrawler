angular.module('newsApp').controller('MainCtrl', [
    '$scope'
    'TaiwanService'
    'News'
    '$timeout'
    '$interval'
    ($scope, TaiwanService, News, $timeout, $interval) ->
        $scope.News = News
        $scope.search_key_word = '';
        moment.locale('zh-tw');

        $scope.init = () ->
            $('#scroll').perfectScrollbar()

        News.getLatestNews().then((news) ->
            $scope.news = news
        )

        $scope.getNextNews = () ->
            if (News.is_search_mode)
                News.searchNews($scope.search_key_word).then((news) ->
                    $scope.news = news
                )
            else
                News.getBeforeNews().then((news) ->
                    $scope.news = news
                )

        $scope.hoverMaps = (report) ->
            TaiwanService.hover_map_to_ping(report.region)

        $interval(() ->
            if (News.is_search_mode)
                return
            News.getLatestNews().then((news)->
                $scope.news = news
            )
        ,5000)

        $scope.$watch('search_key_word', (newValue, oldValue) ->
            if (newValue != '')
                News.changeSearchMode(true)
                News.searchNews(newValue).then((news) ->
                    $scope.news = news
                )
            else
                News.changeSearchMode(false)
                News.getLatestNews().then((news)->
                    $scope.news = news
                )
        )

        $timeout(() ->
            $scope.init()
        )

])
.filter('newsTypeToName', () ->
    return (type) ->
        switch type
            when 'chinatimes' then return '中時電子報'
            when 'eastern' then return '東森新聞雲'
            when 'ltn' then return '自由時報'
            when 'nownews' then return '今日新聞'
            when 'settv' then return '三立新聞網'
            when 'udn' then return '聯合新聞網'
            else return type
)
.filter('dateFromNow', () ->
    return (date) ->
        return moment(date).fromNow()
)