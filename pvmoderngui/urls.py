from django.conf.urls import patterns, include, url
from django.contrib import admin

urlpatterns = patterns('pvmoderngui.getPVMData',
    # Examples:
    # url(r'^$', 'pvmoderngui.views.home', name='home'),
    url(r'^init$', 'init', name='init'),
    url(r'^pvm$', 'pvm', name='pvm'),
    url(r'^methods$', 'methods', name='methods'),
    url(r'^index$', 'index', name='index'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
)
