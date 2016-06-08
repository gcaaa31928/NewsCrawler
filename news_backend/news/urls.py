from django.conf.urls import url, patterns
app_name = 'news'
from . import views
urlpatterns = [
    url(r'^list/$', views.lists, name='lists'),
    url(r'^next/$', views.next_news, name='next_news'),
    url(r'^search/$', views.search, name='search'),
    url(r'^count/$', views.count, name='count')
]
