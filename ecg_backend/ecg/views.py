from django.http import JsonResponse
import numpy as np
import time

def ecg_data(request):
    """Generates synthetic ECG data with timestamps."""
    
    num_points = 100  # Number of ECG points per request
    current_time = int(time.time() * 1000)  # Get current time in milliseconds

    # Simulate an ECG waveform using a sine wave with noise
    ecg_values = (np.sin(np.linspace(0, 4 * np.pi, num_points)) 
                  + np.random.normal(0, 0.1, num_points)).tolist()

    timestamps = [(current_time - (num_points - i) * 10) for i in range(num_points)]  # 10ms intervals

    sample_data = {
        "timestamps": timestamps,  # Time in milliseconds
        "ecg_values": ecg_values,  # ECG voltage data
    }

    return JsonResponse(sample_data)
