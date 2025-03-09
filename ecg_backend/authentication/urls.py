from django.urls import path
from .views import RegisterUserView, GetUserProfileView, login_user, logout_user

urlpatterns = [
    path('register/', RegisterUserView.as_view(), name='register'),
    path('profile/<str:username>/', GetUserProfileView.as_view(), name='profile'),
    path('login/', login_user, name='login'),
    path('logout/', logout_user, name='logout'),
]
