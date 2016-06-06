angular.module('newsApp').factory 'News', [
    '$http'
    '$q'
    'Configuration'
    ($http, $q, Configuration) ->
        factory = {}
        factory.url = "#{Configuration.server_end_point}/news"
        factory.news = []
        factory.after =
            datetime: new Date("2016-06-04").getTime() / 1000
            id: Number.MAX_SAFE_INTEGER
        factory.before =
            datetime: null
            id: 0
        factory.before_id
        factory.limit = 50
        factory.busy = false

        factory.handleNews = (data) ->
            for report in data
                if report.author == ""
                    report.author = report.type
            data

        factory.handleLatestNews = (data) ->
            if not data or data.length == 0
                return factory.news
            data = factory.handleNews(data)
            factory.after.datetime = new Date(data[0].date_time).getTime() / 1000
            factory.after.id = data[0].id
            data.reverse()
            for report in data
                factory.news.unshift(report)
            farest_news = factory.news[factory.news.length - 1]
            factory.before.datetime = new Date(farest_news.date_time).getTime() / 1000
            factory.before.id = farest_news.id
            if factory.news.length >= factory.limit
                factory.news = factory.news.slice(0, factory.news.length)
            factory.news

        factory.handleBeforeNews = (data) ->
            for report in data
                factory.news.push(report)
            data = factory.handleNews(data)
            farest_news = factory.news[factory.news.length - 1]
            factory.before.datetime = new Date(farest_news.date_time).getTime() / 1000
            factory.before.id = farest_news.id
            factory.limit = factory.news.length
            factory.news

        factory.getLatestNews = (limit = 15) ->
            $q((resolve, reject) ->
                $http.get("#{factory.url}/list?limit=#{limit}&after=#{factory.after.datetime}&id=#{factory.after.id}"
                ).then((response) ->
                    news = factory.handleLatestNews(response.data)
                    resolve(news)
                , (response) ->
                    reject(response)
                )
            )

        factory.getBeforeNews = (limit = 15) ->
            $q((resolve, reject) ->
                factory.busy = true
                $http.get("#{factory.url}/next?limit=#{limit}&before=#{factory.before.datetime}&id=#{factory.before.id}")
                .then((response) ->
                    news = factory.handleBeforeNews(response.data)
                    factory.busy = false
                    resolve(news)
                , (response) ->
                    factory.busy = false
                    reject(response)
                )
            )
        factory
]