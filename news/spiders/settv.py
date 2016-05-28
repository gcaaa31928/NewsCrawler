# -*- coding: utf-8 -*-
import scrapy
from scrapy.exceptions import CloseSpider
from news.utililties.utility import Utility
from ..items import NewsItem
import dateparser

class SettvSpider(scrapy.Spider):


    name = "settv"
    allowed_domains = ["www.setn.com"]
    start_urls = [
        "http://www.setn.com/ViewAll.aspx?PageGroupID=1"
    ]

    def parse(self, response):
        pages = response.css('.pager a')
        yield scrapy.Request(response.url, callback=self.parse_page)
        for page in pages:
            url = page.css('::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_page)


    def parse_page(self, response):
        news = response.css('.box ul li')
        for new in news:
            url = new.css('a::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_item)


    def parse_item(self, response):
        if response.url == 'http://www.setn.com/default.aspx?e=4':
            raise CloseSpider('Search Failed')
        item = NewsItem()
        item['title'] = response.css('.title h1::text').extract()[0]
        content = response.css('#Content1').extract()[0]
        item['author'] = Utility.get_author(content)
        item['region'] = Utility.get_location(content)

        item['content'] = content
        item['date_time'] = dateparser.parse(response.css('.date::text').extract()[0])
        item['url'] = response.url
        item['type'] = 'settv'

        yield item
