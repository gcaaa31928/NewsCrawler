angular.module('newsApp').factory 'News', [
    '$http'
    '$q'
    'Configuration'
    ($http, $q, Configuration) ->
        factory = {}
        factory.url = "#{Configuration.server_end_point}/news"
        factory.news = []
        factory.after_datetime = new Date("2016-06-04").getTime() / 1000
        factory.before_datetime = null
        factory.limit = 50

        factory.handleLatestNews = (data) ->
            if not data or data.length == 0
                return
            for report in data
                if report.author == ""
                    report.author = report.type
            factory.after_datetime = new Date(data[0].date_time).getTime() / 1000
            data.reverse()
            for report in data
                factory.news.unshift(report)
            if factory.news.length > 50
                factory.news = factory.news.slice(0, 50)
            factory.news

        factory.handleBeforeNews = (data) ->
            for report in data
                factory.news.push(report)
            date_time = factory.news[factory.news.length -1]
            factory.before_datetime = new Date(date_time).getTime() / 1000
            factory.news

        factory.getLatestNews = (limit = 15) ->
            $q((resolve, reject) ->
                $http.get("#{factory.url}/list?limit=#{limit}&after=#{factory.after_datetime}"
                ).then((response) ->
                    news = factory.handleLatestNews(response.data)
                    resolve(news)
                , (response) ->
                    reject(response)
                )
            )

        factory.getBeforeNews = (limit = 15) ->
            $q((resolve, reject) ->
                $http.get("#{factory.url}/next?limit=#{limit}&before=#{factory.after_datetime}"
                ).then((response) ->
                    news = factory.handleBeforeNews(response.data)
                    resolve(news)
                , (response) ->
                    reject(response)
                )
            )
        factory
]