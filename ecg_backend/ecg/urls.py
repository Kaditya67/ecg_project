from django.urls import path
from .views import ecg_data

urlpatterns = [
    path('ecg-data/', ecg_data, name='ecg_data'),
]
