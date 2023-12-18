from django.db import models
from authenticate.models import User
# Create your models here.

class Ticket(models.Model):
    STATUS = (
        (1, 'RAISED'),
        (2, 'PICKED'),
        (3, 'DISPATCHED'),
        (4, 'DESTROYED')
    )
    item_name = models.CharField(max_length=50)
    user_id = models.ForeignKey(User, on_delete=models.CASCADE, related_name='user_ticket')
    serve = models.IntegerField()
    status = models.IntegerField(default=1, choices=STATUS)
    otp = models.IntegerField()
    description = models.CharField(max_length=200)
    created_at = models.DateTimeField(auto_now=True)
    dispatch_at = models.DateTimeField(auto_now=True)
    destroyed_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.item_name

 # reference for media code https://dev.to/thomz/uploading-images-to-django-rest-framework-from-forms-in-react-3jhj
class Feed(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE, related_name='user_feed')
    title = models.CharField(max_length=50, null=True, blank=True)
    media = models.FileField(upload_to="media/", null=True, blank=True)
    description = models.CharField(max_length=500, null=True, blank=True)
    created_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return '%s by %s' % (self.title, self.user_id.first_name)

class Like(models.Model):
    user_id = models.ManyToManyField(User, related_name='user_like') 
    feed = models.ForeignKey(Feed, on_delete=models.CASCADE, related_name='feed_like')
    created_at = models.DateTimeField(auto_now=True)

class Comment(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE, related_name='user_comment')
    comment_text = models.CharField(max_length=500)
    feed = models.ForeignKey(Feed, on_delete=models.CASCADE, related_name='feed_comment')
    created_at = models.DateTimeField(auto_now=True)