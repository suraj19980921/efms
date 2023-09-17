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
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    serve = models.IntegerField()
    status = models.IntegerField(default=1, choices=STATUS)
    otp = models.IntegerField()
    description = models.CharField(max_length=200)
    created_at = models.DateTimeField(auto_now=True)
    dispatch_at = models.DateTimeField(auto_now=True)
    destroyed_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.item_name