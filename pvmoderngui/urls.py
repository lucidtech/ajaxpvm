from django.conf.urls import patterns, include, url
from django.contrib import admin

urlpatterns = patterns('pvmoderngui.getPVMData',

    url(r'^$', 'init', name='init'),
    url(r'^init$', 'init', name='init'),
    url(r'^pvm$', 'pvm', name='pvm'),
    url(r'^methods$', 'methods', name='methods'),
    url(r'^views$', 'views', name='views'),
    url(r'^index$', 'index', name='index'),

)
