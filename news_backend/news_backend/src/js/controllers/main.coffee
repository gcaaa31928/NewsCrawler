angular.module('newsApp').controller('MainCtrl', [
    '$scope'
    'TaiwanService'
    'News'
    ($scope, TaiwanService, News) ->
        moment.locale('zh-tw');
        setTimeout(() ->
            TaiwanService.d3_render_ping(25.060843, 121.544125);
        , 1000)

        News.getLatestNews().then((news) ->
            $scope.news = news
            console.log news
        )

        $scope.getNextNews = () ->
            News.getBeforeNews().then((news) ->
                $scope.news = news
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