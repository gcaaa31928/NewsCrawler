# -*- coding: utf-8 -*-
import scrapy
from scrapy.exceptions import CloseSpider
from news.utililties.utility import Utility
from ..items import NewsItem
import dateparser


class EasternSpider(scrapy.Spider):
    name = "eastern"
    allowed_domains = ["ettoday.net"]
    start_urls = [
        "http://www.ettoday.net/news/news-list.htm"
    ]

    def parse(self, response):
        pages = response.css('.menu_page a')
        yield scrapy.Request(response.url, callback=self.parse_page)
        for page in pages:
            url = page.css('::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_page)


    def parse_page(self, response):
        hot_news = response.css('.part_list_1 h3')
        for hot_new in hot_news:
            url = hot_new.css('a::attr("href")').extract()[0]
            yield scrapy.Request(response.urljoin(url), callback=self.parse_item)


    def parse_item(self, response):
        if response.css('.error_404').extract():
            raise CloseSpider('Search Failed')
        if response.css('article .title').extract():
            titles = response.css('article .title::text').extract()
            item = NewsItem()
            item['title'] = titles[0]
            content = response.css('.story').extract()[0]
            item['region'] = Utility.get_location(content)

            item['content'] = content
            if response.css('.date::text').extract():
                item['date_time'] = dateparser.parse(response.css('.date::text').extract()[0])
            item['url'] = response.url
            item['type'] = 'eastern'

            yield item
