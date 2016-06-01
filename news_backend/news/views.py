from django.shortcuts import render

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse

from news.serializers import NewSerializer

from news.models import News


@api_view(['GET'])
def lists(request):
    news = News.objects.all()
    serializer = NewSerializer(news)
    return Response(serializer.data)
