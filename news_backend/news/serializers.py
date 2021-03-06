from rest_framework import serializers
from news.models import News

class NewSerializer(serializers.ModelSerializer):
    class Meta:
        model = News
        fields = ('id', 'title', 'author', 'date_time', 'region', 'url', 'type')