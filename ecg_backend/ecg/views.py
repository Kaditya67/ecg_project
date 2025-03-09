from django.http import JsonResponse
import numpy as np
import time
from scipy.signal import find_peaks, butter, sosfiltfilt
from scipy.stats import zscore

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

from django.http import JsonResponse
import numpy as np
import time
from scipy.signal import find_peaks, butter, sosfiltfilt
from scipy.stats import zscore

def butter_bandpass(lowcut, highcut, fs, order=3):
    """Create a bandpass Butterworth filter using second-order sections."""
    nyquist = 0.5 * fs
    low = lowcut / nyquist
    high = highcut / nyquist
    sos = butter(order, [low, high], btype='band', output='sos')
    return sos

def process_pulse_data(request):
    """Processes ECG data & returns essential metrics with extended analysis."""
    try:
        # Configuration
        SAMPLING_RATE = 100  # Hz
        DURATION = 30  # Seconds
        BASE_BPM = 72
        NOISE_LEVEL = 10
        SCANNED = True  # Ensure scanning is completed

        if not SCANNED:
            return JsonResponse({"scanned": False, "msg": "Scan in progress..."})

        # Generate synthetic ECG-like data
        t = np.linspace(0, DURATION, SAMPLING_RATE * DURATION)
        base_freq = BASE_BPM / 60 + 0.1 * np.sin(2 * np.pi * 0.05 * t)
        main_signal = np.sin(2 * np.pi * base_freq * t) * 50

        # Add noise & artifacts
        synthetic_data = (
            main_signal
            + np.sin(2 * np.pi * 0.2 * t) * 8
            + np.sin(2 * np.pi * 0.05 * t) * 15
            + np.random.normal(0, NOISE_LEVEL, len(t))
        )

        # Bandpass filtering
        sos = butter_bandpass(0.5, 4.0, SAMPLING_RATE)
        filtered = sosfiltfilt(sos, synthetic_data)

        # Peak detection
        threshold = np.mean(filtered) + 0.6 * np.std(filtered)
        peaks, _ = find_peaks(filtered, height=threshold, distance=SAMPLING_RATE * 0.3)

        if len(peaks) < 4:
            return JsonResponse({"scanned": True, "msg": "Insufficient heartbeats detected"})

        # Calculate RR intervals
        rr_intervals = np.diff(peaks) / SAMPLING_RATE * 1000
        valid_intervals = rr_intervals[np.abs(zscore(rr_intervals)) < 3]

        if len(valid_intervals) < 2:
            return JsonResponse({"scanned": True, "msg": "Excessive irregular heartbeats"})

        # BPM Calculation
        bpm_mean = int(60000 / np.mean(valid_intervals))
        bpm_median = int(60000 / np.median(valid_intervals))

        # Arrhythmia Detection
        arrhythmia = {
            "bradycardia": bpm_mean < 60,
            "tachycardia": bpm_mean > 100,
            "rr_variability": round(np.std(valid_intervals) / np.mean(valid_intervals) * 100, 1)
        }

        # Signal Quality
        noise_floor = np.std(filtered - sosfiltfilt(sos, filtered))
        snr = 20 * np.log10(np.std(filtered) / noise_floor)
        signal_quality = {
            "snr_db": round(snr, 1),
            "peak_confidence": round(len(valid_intervals) / len(rr_intervals), 2)
        }

        # Additional Deductions
        health_meter = max(0, min(100, 100 - abs(bpm_mean - 72)))  # 100 = perfect health
        oxygen_level = f"{max(94, min(99, 97 + (72 - bpm_mean) * 0.1))}%"
        happy_index = max(0, min(100, 100 - arrhythmia['rr_variability']))
        stress_level = "High" if arrhythmia['rr_variability'] > 20 else "Moderate" if arrhythmia['rr_variability'] > 10 else "Low"
        energy_index = max(0, min(100, 100 - abs(bpm_mean - 72) * 1.5))
        fatigue_indicator = "High" if bpm_mean < 65 else "Normal" if 65 <= bpm_mean <= 85 else "Fatigued"

        # Response
        response = {
            "scanned": True,
            "msg": "Scan successful",
            "bpm": {"mean": bpm_mean, "median": bpm_median},
            "arrhythmia": arrhythmia,
            "signal_quality": signal_quality,
            "deductions": {
                "health_meter": health_meter,
                "oxygen_level": oxygen_level,
                "happy_index": happy_index,
                "stress_level": stress_level,
                "energy_index": energy_index,
                "fatigue_indicator": fatigue_indicator
            },
            "pulse_data": {
                "filtered": np.round(filtered[::10]).astype(int).tolist(),
                "peaks": (peaks[::10] / SAMPLING_RATE).tolist()
            }
        }

        return JsonResponse(response, json_dumps_params={"indent": 2})

    except ValueError as ve:
        return JsonResponse({"scanned": False, "msg": f"Invalid data: {str(ve)}"})
    except Exception as e:
        return JsonResponse({"scanned": False, "msg": f"Processing error: {str(e)}"})