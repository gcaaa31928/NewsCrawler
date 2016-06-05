from django.shortcuts import render

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse

from news.serializers import NewSerializer

from news.models import News


@api_view(['GET'])
def lists(request):
    limit = request.GET.get('limit', 10)
    news = News.objects.all()[:int(limit)]
    # print news[0].date_time + '123'
    serializer = NewSerializer(news, many=True)
    return Response(serializer.data)
