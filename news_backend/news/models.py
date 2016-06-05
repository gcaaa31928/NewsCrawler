from __future__ import unicode_literals

from django.db import models

# Create your models here.
class News(models.Model):
    title = models.CharField(max_length=150, blank=True, default='')
    author = models.CharField(max_length=100, blank=True, default='')
    date_time = models.DateTimeField(blank=False)
    region = models.CharField(max_length=30, blank=True, default='')
    content = models.TextField()
    url = models.CharField(max_length=100, blank=True, default='')
    type = models.CharField(max_length=20, blank=True, default='')

    class Meta:
        ordering = ('-date_time',)