from time import sleep

import scrapy
from scrapy.utils.project import get_project_settings
from scrapy.utils.log import configure_logging
from twisted.internet import reactor

from news.spiders import *
from scrapy.crawler import CrawlerRunner


settings = get_project_settings()
runner = CrawlerRunner(settings)
runner.crawl(NowNewsSpider)
runner.crawl(ChinaTimesSpider)
runner.crawl(EasternSpider)
runner.crawl(SettvSpider)
runner.crawl(UDNSpider)
runner.crawl(AppleDailySpider)
runner.crawl(NextMagSpider)
d = runner.join()
d.addBoth(lambda _: reactor.stop())

reactor.run()
