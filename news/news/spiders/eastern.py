# -*- coding: utf-8 -*-
import scrapy


class EasternSpider(scrapy.Spider):
    name = "eastern"
    allowed_domains = ["http://star.ettoday.net"]
    start_urls = (
        "http://star.ettoday.net/news/%d" % int(i+1) for i in range(197075, 697075)
    )

    def parse(self, response):
        pass
