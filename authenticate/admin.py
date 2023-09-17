from django.contrib import admin
from authenticate.models import User, UserRelationDetail, SignupTemp

# Register your models here.
admin.site.register(User)
admin.site.register(UserRelationDetail)
admin.site.register(SignupTemp)
