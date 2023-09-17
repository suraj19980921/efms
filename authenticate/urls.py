from django.urls import path, include
from rest_framework_simplejwt import views as jwt_views
from .views import UserViewSet
from rest_framework.routers import DefaultRouter

router = DefaultRouter()

router.register(r"user", UserViewSet, basename='user')

urlpatterns = [
    path('', include(router.urls)),
]
# urlpatterns = [
# 	path('api/token/', jwt_views.TokenObtainPairView.as_view(), name ='token_obtain_pair'),
# 	path('api/token/refresh/', jwt_views.TokenRefreshView.as_view(), name ='token_refresh'),
#     path('register/', views.register_user)
# ]
