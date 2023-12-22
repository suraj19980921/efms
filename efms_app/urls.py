from django.urls import path, include
from .views import FeedsViewset, TicketsViewset
from rest_framework.routers import DefaultRouter

router = DefaultRouter()

router.register(r"feeds", FeedsViewset, basename='feeds')
router.register(r"ticket", TicketsViewset, basename='tickets')

urlpatterns = [
    path('', include(router.urls)),
]