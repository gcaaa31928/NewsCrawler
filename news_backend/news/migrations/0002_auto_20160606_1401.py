# -*- coding: utf-8 -*-
# Generated by Django 1.9.6 on 2016-06-06 06:01
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('news', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='news',
            options={'ordering': ('-date_time', 'id')},
        ),
        migrations.AlterField(
            model_name='news',
            name='url',
            field=models.CharField(blank=True, default='', max_length=100, unique=True),
        ),
    ]