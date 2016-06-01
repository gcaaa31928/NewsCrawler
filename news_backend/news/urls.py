from django.conf.urls import url, patterns
app_name = 'news'
from . import views
urlpatterns = [
    url(r'^list/$', views.lists, name='lists')
]
