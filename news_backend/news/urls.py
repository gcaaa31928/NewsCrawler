from django.conf.urls import url, patterns
urlpatterns = patterns(
    'news.views',
    url(r'^list/$', 'lists', name='lists')
)
