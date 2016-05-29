# -*- coding: utf-8 -*-
import scrapy
from scrapy.exceptions import CloseSpider
from news.utililties.utility import Utility
from ..items import NewsItem
import dateparser
import re

class LTNSpider(scrapy.Spider):
    name = "ltn"
    allowed_domains = [
        "news.ltn.com.tw"
    ]
    start_urls = [
        "http://news.ltn.com.tw/list/BreakingNews"
    ]

    def parse(self, response):
        pagers= response.css('#page a')
        for pager in pagers:
            url = pager.css('::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_page)

    def parse_page(self, response):
        table = response.css('#newslistul .lipic > a')
        for row in table:
            url = row.css('::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_news)

    def parse_news(self, response):
        titles = response.css('.content h1::text').extract()
        if len(titles) == 0:
            yield None
        item = NewsItem()
        item['title'] = titles[0]
        content = response.css('.content').extract()[0]

        item['content'] = content
        matches = re.search('(\d{4}-\d{2}-\d{2}).*(\d{2}.*\d{2})', content)
        date_time = matches.group(1) + "  " +  matches.group(2)
        print date_time
        item['date_time'] = dateparser.parse(date_time)
        item['region'] = Utility.get_location(content)
        item['author'] = Utility.get_author(content)
        item['url'] = response.url
        item['type'] = 'ltn'
        yield item
