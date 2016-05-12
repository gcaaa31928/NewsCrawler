from scrapy.spider import Spider
from scrapy.selector import Selector
class EasternNewsSpider(Spider):
    name = "eastern_news"
    allowed_domains = ["http://star.ettoday.net/news"]
    star_urls = ["http://star.ettoday.net/news/697074"]

    def parse(self, response):
        sel = Selector(response)
