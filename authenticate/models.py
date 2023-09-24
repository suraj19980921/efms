from django.db import models
from django.contrib.auth.models import User
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _
from .managers import CustomUserManager

# Create your models here.
class User(AbstractUser):
    ROLES = (
       (1, 'SUPERADMIN'),
       (2, 'ADMIN'),
       (3, 'SUB-ADMIN'),
    )
    username = None
    email = models.EmailField(_("email address"), unique=True)
    access_role = models.IntegerField(default=3, choices = ROLES)
    address = models.CharField(max_length=200)
    phone_no = models.IntegerField(unique=True)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    objects = CustomUserManager()

    def __str__(self):
        return self.email

class SignupTemp(models.Model):
    ROLES = (
       (1, 'SUPERADMIN'),
       (2, 'ADMIN'),
       (3, 'SUB-ADMIN'),
    )
    first_name = models.CharField(max_length=100, blank=True, null=True)
    last_name = models.CharField(max_length=100, blank=True, null=True)
    password = models.CharField(max_length=200, blank=True, null=True)
    email = models.EmailField(blank=True, null=True)
    access_role = models.IntegerField(choices = ROLES,blank=True, null=True)
    address = models.CharField(max_length=200, blank=True, null=True)
    phone_no = models.IntegerField(blank=True, null=True)
    otp = models.IntegerField(unique=True, blank=True, null=True)
    def __str__(self):
        return f"{self.first_name} {self.last_name}"


class UserRelationDetail(models.Model):
    RELATION_TYPE = (
        (1, 'House'),
        (2, 'NGO'),
        (3, 'RESTAURANT'),
        (4, 'EVENTS')
    )
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    address = models.CharField(max_length=200)
    phone_no = models.IntegerField(unique=True)
    registration_number = models.IntegerField(unique=True)
    type = models.IntegerField(default=1, choices = RELATION_TYPE)

    def __str__(self) -> str:
        return self.name