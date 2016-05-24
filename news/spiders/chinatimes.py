# -*- coding: utf-8 -*-
import scrapy
from scrapy.exceptions import CloseSpider
from news.utililties.utility import Utility
from ..items import NewsItem
import dateparser

class ChinaTimesSpider(scrapy.Spider):
    name = "chinatimes"
    allowed_domains = ["www.chinatimes.com"]
    start_urls = [
        "http://www.chinatimes.com/realtimenews/"
    ]

    def parse(self, response):
        table = response.css('.listLeft ul li')
        for row in table:
            url = row.css('a::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_label)


    def parse_label(self, response):
        table = response.css('.listRight ul li')
        for row in table:
            url = row.css('h2 a::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_news)

    def parse_news(self, response):
        page = response.css('.page_container')
        item = NewsItem()
        item['title'] = page.css('article header h1::text').extract()[0]
        item['date_time'] = dateparser.parse(page.css('.reporter time::text').extract()[0])
        item['author'] = page.css('.rp_name cite a::text').extract()[0]
        item['url'] = response.url
        item['type'] = 'chinatimes'
        content = page.css('article article').extract()[0]
        item['content'] = content
        item['region'] = Utility.get_location(content)
        yield item


