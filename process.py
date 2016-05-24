import scrapy
from scrapy.utils.project import get_project_settings

from news.spiders import *
from scrapy.crawler import CrawlerProcess

settings = get_project_settings()
process = CrawlerProcess(settings)
process.crawl(NowNewsSpider)
process.crawl(ChinaTimesSpider)
process.crawl(EasternSpider)
process.crawl(SettvSpider)
process.crawl(UDNSpider)
process.start()