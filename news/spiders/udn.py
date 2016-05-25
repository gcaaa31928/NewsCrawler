# -*- coding: utf-8 -*-
import scrapy
from scrapy.exceptions import CloseSpider
from news.utililties.utility import Utility
from ..items import NewsItem
import dateparser

class UDNSpider(scrapy.Spider):
    name = "udn"
    allowed_domains = [
        "udn.com"
    ]
    start_urls = [
        "http://udn.com/news/breaknews/1"
    ]

    def parse(self, response):
        pagers= response.css('.pagelink a')
        for pager in pagers:
            url = pager.css('::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_page)

    def parse_page(self, response):
        table = response.css('#breaknews_body dl dt')
        for row in table:
            url = row.css('dt a::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_news)

    def parse_news(self, response):
        item = NewsItem()
        item['title'] = response.css('#story_art_title::text').extract()[0]
        content = response.css('#story_body_content').extract()[0]
        item['region'] = Utility.get_location(content)

        item['content'] = content
        item['date_time'] = dateparser.parse(response.css('#story_bady_info h3::text').extract()[0])
        item['url'] = response.url
        item['type'] = 'udn'
        yield item
