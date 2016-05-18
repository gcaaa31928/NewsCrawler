import itertools
import re
class Utility():
    locations_name = ['台北','臺北','新北','桃園','臺中''台中','臺南','台南','高雄','基隆','新竹市','嘉義','新竹','苗栗''彰化','南投',
                      '雲林','嘉義','屏東','宜蘭','花蓮','臺東','台東','澎湖']
    @classmethod
    def get_location(cls, content):
        regex_string = '('
        for name in itertools.islice(cls.locations_name, 0, len(cls.locations_name) - 1):
            regex_string += name + '|'
        regex_string += cls.locations_name + ')'
        regex = re.compile(regex_string)
        return regex.match(content)

