# -*- coding: utf-8 -*-
import scrapy
from scrapy.exceptions import CloseSpider
from news.utililties.utility import Utility
from ..items import NewsItem
import dateparser


class NextMagSpider(scrapy.Spider):
    name = "nextmag"
    allowed_domains = ["www.nextmag.com.tw"]
    start_urls = [
        "http://www.nextmag.com.tw/breaking-news"
    ]

    def parse(self, response):
        table = response.css('.mod-body ul li')
        for row in table:
            url = row.css('a::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_item)

    def parse_item(self, response):
        page = response.css('.mod-article')
        item = NewsItem()
        item['title'] = page.css('.headline::text').extract()[0]
        item['date_time'] = dateparser.parse(page.css('.meta-bar time::text').extract()[0])
        item['url'] = response.url
        item['type'] = 'nextmag'
        content = page.css('article article').extract()[0]
        item['content'] = content
        item['author'] =
        item['region'] = Utility.get_location(content)
        yield item
