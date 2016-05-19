# -*- coding: utf-8 -*-
import scrapy
from scrapy.exceptions import CloseSpider
from news.utililties.utility import Utility
from ..items import NewsItem
import dateparser

class SettvSpider(scrapy.Spider):


    name = "settv"
    allowed_domains = ["http://www.setn.com"]
    start_urls = (
        "http://www.setn.com/News.aspx?NewsID=%d" % int(i) for i in range(148002, 148003)
    )

    def parse(self, response):
        # if response.css('.error_404').extract():
        #     raise CloseSpider('Search Failed')
        item = NewsItem()
        item['title'] = response.css('.title h1::text').extract()[0]
        content = response.css('#Content1').extract()[0]
        item['region'] = Utility.get_location(content)

        item['content'] = content
        item['date_time'] = dateparser.parse(response.css('.date::text').extract()[0])
        item['url'] = response.url
        item['type'] = 'settv'

        yield item
