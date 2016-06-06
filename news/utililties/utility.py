#coding=utf-8
import itertools
import re


class Utility():
    locations_name = [u'台北',u'臺北', u'新北', u'桃園', u'臺中', u'台中',
                      u'臺南',u'台南', u'高雄', u'基隆', u'新竹', u'嘉義',
                      u'新竹',u'苗栗', u'彰化', u'南投', u'雲林', u'嘉義',
                      u'屏東',u'宜蘭', u'花蓮', u'臺東', u'台東', u'澎湖']
    def __init__(self):
        pass

    @classmethod
    def get_location(cls, content):
        # content.encode('utf8')
        regex_string = '('
        for name in itertools.islice(cls.locations_name, 0, len(cls.locations_name) - 1):
            regex_string += name + '|'
        regex_string += cls.locations_name[-1] + ')'
        matches = re.search(regex_string, content)
        if matches is None:
            return ''
        return matches.group(0)

    @classmethod
    def get_author(cls, content):
        matches = re.search(u'記者(.+)／.*報導', content)
        if matches is None:
            return ''
        return matches.group(1)

    @classmethod
    def get_apple_author(cls, content):
        matches = re.search(u'（(.+)／.*報導）', content)
        if matches is None:
            return ''
        return matches.group(1)