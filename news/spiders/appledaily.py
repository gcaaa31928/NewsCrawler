# -*- coding: utf-8 -*-
import scrapy
from scrapy.exceptions import CloseSpider

from news.utililties.utility import Utility
from ..items import NewsItem
import dateparser

class AppleDailySpider(scrapy.Spider):
    name = "appledaily"
    allowed_domains = ["www.appledaily.com.tw"]
    start_urls = [
        "http://www.appledaily.com.tw/realtimenews/section/new/"
    ]

    def parse(self, response):
        table = response.css('.page_switch a')
        for row in table:
            url = row.css('::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_label)


    def parse_label(self, response):
        table = response.css('ul.rtddd li')
        for row in table:
            url = row.css('a::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_news)

    def parse_news(self, response):
        page = response.css('#maincontent')
        item = NewsItem()
        item['title'] = page.css('#h1::text').extract()[0]
        item['date_time'] = dateparser.parse(page.css('.gggs time::text').extract()[0])
        item['url'] = response.url
        item['type'] = 'appledaily'
        content = page.css('#summary').extract()[0]
        item['content'] = content
        item['author'] = Utility.get_apple_author(content)
        item['region'] = Utility.get_location(content)
        yield item


