from datetime import datetime

import sys
from django.db.models import Q
from django.shortcuts import render

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse

from news.serializers import NewSerializer

from news.models import News


def get_current_utc_epoch_time():
    epoch = datetime(1970, 1, 1)
    now = datetime.utcnow()
    return (now - epoch).total_seconds()


@api_view(['GET'])
def lists(request):
    limit = request.GET.get('limit', 10)
    epoch = datetime(1970, 1, 1)
    now = datetime.utcnow()
    after_timestamp = int(request.GET.get('after', (now - epoch).total_seconds()))
    id = int(request.GET.get('id', 0))
    after_datetime = datetime.utcfromtimestamp(after_timestamp)
    query = Q(date_time__gte=after_datetime) & ~Q(pk=id)
    news = News.objects.filter(query)[:int(limit)]
    # print news[0].date_time + '123'
    serializer = NewSerializer(news, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def next_news(request):
    limit = request.GET.get('limit', 10)
    epoch = datetime(1970, 1, 1)
    now = datetime.utcnow()
    before_timestamp = int(request.GET.get('before', (now - epoch).total_seconds()))
    id = int(request.GET.get('id', 0))
    before_datetime = datetime.utcfromtimestamp(before_timestamp)
    query = Q(date_time__lte=before_datetime) & ~Q(pk=id)
    news = News.objects.filter(query)[:int(limit)]
    serializer = NewSerializer(news, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def search(request):
    limit = request.GET.get('limit', 10)
    search_words = request.GET.get('q', '')
    before_timestamp = int(request.GET.get('before', get_current_utc_epoch_time()))
    id = int(request.GET.get('id', -1))
    before_datetime = datetime.utcfromtimestamp(before_timestamp)

    query = (Q(date_time__lte=before_datetime) & ~Q(pk=id)) & \
            (Q(title__contains=search_words) |
             Q(author__contains=search_words) |
             Q(content__contains=search_words) |
             Q(region__contains=search_words))

    news = News.objects.filter(query)[:int(limit)]
    serializer = NewSerializer(news, many=True)
    return Response(serializer.data)
