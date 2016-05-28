# -*- coding: utf-8 -*-
import scrapy
from scrapy.exceptions import CloseSpider
from news.utililties.utility import Utility
from ..items import NewsItem
import dateparser

class NowNewsSpider(scrapy.Spider):
    name = "nownews"
    allowed_domains = [
        "www.nownews.com"
    ]
    start_urls = [
        "http://www.nownews.com/"
    ]


    def parse(self, response):
        table = response.css('.tab-content .tab-pane ')[1]
        for row in table.css('.list li'):
            url = row.css('a::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_news)

    def parse_news(self, response):
        item = NewsItem()
        item['title'] = response.css('.content-title::text').extract()[0]
        header = response.css('.views-counter::text').extract()[0]
        content = response.css('.body').extract()[0]
        reporter_content = response.css('.views-counter').extract()[0]
        content = header + content
        item['author'] = Utility.get_author(reporter_content)
        item['region'] = Utility.get_location(content)
        item['content'] = content
        item['date_time'] = dateparser.parse(response.css('.news-info::text').extract()[0])
        item['url'] = response.url
        item['type'] = 'nownews'
        yield item
