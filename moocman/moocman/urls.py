from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.http import HttpResponsePermanentRedirect

urlpatterns = patterns('',
    # Examples:
    url(r'^$', lambda r: HttpResponsePermanentRedirect('admin/')),
    url(r'^courses/', include('courses.urls')),

    url(r'^admin/', include(admin.site.urls)),
)
