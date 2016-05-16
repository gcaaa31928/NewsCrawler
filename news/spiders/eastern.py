# -*- coding: utf-8 -*-
import scrapy

from ..items import NewsItem
import dateparser

class EasternSpider(scrapy.Spider):
    name = "eastern"
    allowed_domains = ["http://star.ettoday.net"]
    start_urls = (
        "http://star.ettoday.net/news/%d" % int(i) for i in range(697075, 697076)
    )

    def parse(self, response):
        item = NewsItem()
        item['title'] = response.css('.title::text').extract()[0]
        item['content'] = response.css('.story::text').extract()[0]
        item['date'] = dateparser.parse(response.css('.date::text').extract()[0])
        item['url'] = response.url
        item['type'] = 'eastern'

        yield item
