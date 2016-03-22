from django.db import models
#task model
class Task(models.Model):
    name_text=models.CharField(max_length=30)
    desc_text=models.CharField(max_length=200)
    start_date = models.DateField('date start',null=True,blank=True)
    end_date = models.DateField('date end',null=True,blank=True)
    progress = models.IntegerField(default=0)
    comment_text = models.CharField(max_length=200,null=True,blank=True)

    def __str__(self):
        return self.name_text
    
#category model
class Category(models.Model):
    name_text=models.CharField(max_length=10)
    desc_text=models.CharField(max_length=200)

    def __str__(self):
        return self.name_text

#vendor model
class Vendor(models.Model):
    name_text=models.CharField(max_length=20)
    desc_text=models.CharField(max_length=200)
    url = models.URLField(default='')
    
    def url_as_link(self):
        return '<a href="%s;">%s</a>' % (self.url, self.url)
    url_as_link.allow_tags=True

    def __str__(self):
        return self.name_text

#resourse model
class Resource(models.Model):
    category = models.ForeignKey(Category)
    name_text = models.CharField(max_length=200)
    url = models.URLField(default='',null=True,blank=True)
    progress = models.IntegerField(default=0)
    comment_text = models.CharField(max_length=200,null=True,blank=True)

    def url_as_link(self):
        return '<a href="%s;">%s</a>' % (self.url, self.url)
    url_as_link.allow_tags=True

    def __str__(self):
        return self.name_text


#course model
class Course(models.Model):
    vendor = models.ForeignKey(Vendor)
    category = models.ForeignKey(Category)
    name_text = models.CharField(max_length=200)
    start_date = models.DateField('date start',null=True,blank=True)
    end_date = models.DateField('date end',null=True,blank=True)
    weekhours = models.IntegerField(default=0)
    weeks = models.IntegerField(default=0)
    progress = models.IntegerField(default=0)
    comment_text = models.CharField(max_length=200,null=True,blank=True)
    url = models.URLField(default='',null=True,blank=True)

    def url_as_link(self):
        if self.url:
            return '<a href="%s">%s</a>' % (self.url, "Open Class")
        else:
            return ''
    url_as_link.allow_tags=True

    def __str__(self):
        return self.name_text
