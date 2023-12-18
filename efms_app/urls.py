from django.urls import path, include
from .views import FeedsViewset
from rest_framework.routers import DefaultRouter

router = DefaultRouter()

router.register(r"feeds", FeedsViewset, basename='feeds')

urlpatterns = [
    path('', include(router.urls)),
]