from django.urls import path, include
from .views import ecg_data, process_pulse_data

urlpatterns = [
    path('ecg-data/', ecg_data, name='ecg_data'),
    path('ecg/process/', process_pulse_data, name='process_pulse_data'),
    path("auth/", include("authentication.urls")),
]
