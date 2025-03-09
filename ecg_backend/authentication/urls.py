from django.urls import path
from .views import register_user, get_user_profile

urlpatterns = [
    path('register/', register_user, name='register_user'),
    path('profile/<str:username>/', get_user_profile, name='get_user_profile'),
]
