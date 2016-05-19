# -*- coding: utf-8 -*-
import scrapy
from scrapy.exceptions import CloseSpider
from news.utililties.utility import Utility
from ..items import NewsItem
import dateparser

class EasternSpider(scrapy.Spider):
    name = "eastern"
    allowed_domains = ["http://star.ettoday.net"]
    start_urls = (
        "http://star.ettoday.net/news/%d" % int(i) for i in range(997075, 997076)
    )

    def parse(self, response):
        if response.css('.error_404') is not None:
            raise CloseSpider('Search Failed')
        item = NewsItem()
        item['title'] = response.css('.title::text').extract()[0]
        content = response.css('.story').extract()[0]
        item['region'] = Utility.get_location(content)

        item['content'] = content
        item['date_time'] = dateparser.parse(response.css('.date::text').extract()[0])
        item['url'] = response.url
        item['type'] = 'eastern'

        yield item
