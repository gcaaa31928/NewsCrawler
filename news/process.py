import scrapy
from news.spiders import *
from scrapy.crawler import CrawlerProcess
process = CrawlerProcess()
process.crawl(NowNewsSpider)
# process.crawl(ChinaTimesSpider)
process.crawl(EasternSpider)
process.crawl(SettvSpider)
process.crawl(UDNSpider)
process.start()