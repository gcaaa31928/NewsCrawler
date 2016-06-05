from datetime import datetime
from django.shortcuts import render

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse

from news.serializers import NewSerializer

from news.models import News


@api_view(['GET'])
def lists(request):
    limit = request.GET.get('limit', 10)
    epoch = datetime(1970, 1, 1)
    now = datetime.utcnow()
    after_timestamp = int(request.GET.get('after', (now - epoch).total_seconds()))
    after_datetime = datetime.fromtimestamp(after_timestamp)
    news = News.objects.filter(date_time__gte=after_datetime)[:int(limit)]
    # print news[0].date_time + '123'
    serializer = NewSerializer(news, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def next_news(request):
    limit = request.GET.get('limit', 10)
    print datetime.utcnow()
    epoch = datetime(1970, 1, 1)
    now = datetime.utcnow()
    before_timestamp = int(request.GET.get('before', (now - epoch).total_seconds()))
    before_datetime = datetime.fromtimestamp(before_timestamp)
    news = News.objects.filter(date_time__lte=before_datetime)[:int(limit)]
    # print news[0].date_time + '123'
    serializer = NewSerializer(news, many=True)
    return Response(serializer.data)
