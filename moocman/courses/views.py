from django.shortcuts import render
from django.http import HttpResponse
from django.template import RequestContext,loader
from courses.models import Course
# Create your views here.
def index(request):
    course_list = Course.objects.order_by('start_date')[:]
    template = loader.get_template('courses/index.html')
    context=RequestContext(request,{
        'course_list':course_list,
    })
    return HttpResponse(template.render(context))

