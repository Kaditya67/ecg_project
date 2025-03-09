from django.urls import path
from .views import RegisterUserView, GetUserProfileView

urlpatterns = [
    path('register/', RegisterUserView.as_view(), name='register'),
    path('profile/<str:username>/', GetUserProfileView.as_view(), name='get_profile'),
]
