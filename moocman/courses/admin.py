from django.contrib import admin
from courses.models import Category
from courses.models import Vendor
from courses.models import Course
from courses.models import Task
from courses.models import Resource


class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name_text','desc_text']


class VendorAdmin(admin.ModelAdmin):
    list_display = ['name_text','desc_text','url_as_link']

class ResourceAdmin(admin.ModelAdmin):
    list_display = ['category', 'name_text', 'url_as_link','comment_text','progress']
class CourseAdmin(admin.ModelAdmin):
    list_display = ['name_text', 'vendor','category', 'comment_text','start_date','end_date','weeks', 'progress','url_as_link']
    list_filter = ['start_date','progress','category','vendor']

class TaskAdmin(admin.ModelAdmin):
    list_display = ['name_text','desc_text', 'comment_text','start_date', 'end_date','progress']
# Register your models here.
admin.site.register(Category,CategoryAdmin)
admin.site.register(Vendor,VendorAdmin)
admin.site.register(Course,CourseAdmin)
admin.site.register(Task,TaskAdmin)
admin.site.register(Resource,ResourceAdmin)
