# 📲 ECG Monitoring App

A **Flutter** mobile application that reads ECG pulse data from an ECG sensor, processes it, and provides real-time visualizations along with AI-based analysis.

## 🚀 Features
- **Real-time ECG Data Visualization** using `fl_chart`.
- **Bluetooth/Serial Communication** for data acquisition.
- **AI/ML-based Analysis** for detecting anomalies.
- **Heart Rate Calculation (BPM)**
- **History & Reports** for tracking ECG trends.
- **User Authentication & Profiles** (Future scope).

## 🛠️ Installation & Setup

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/yourusername/ecg-monitor.git
cd ecg-monitor
```

### 2️⃣ Install Dependencies
```bash
flutter pub get
```

### 3️⃣ Run the Application
```bash
flutter run
```
Make sure a device or emulator is connected.

## 📡 Connecting to ECG Sensor
- Ensure the **Arduino Nano** and **ECG AD8232 Sensor** are properly set up.
- Modify the `ApiService` class to fetch data from your hardware.
- Use Bluetooth/Serial communication if required.

## 📚 Dependencies
- `fl_chart` (for ECG graph visualization)
- `provider` (state management)
- `http` (for API communication)

## 🏗️ Future Enhancements
- **Cloud Sync & User Authentication**
- **Advanced AI Analysis for Arrhythmia Detection**
- **Custom Alerts & Notifications**

## 📜 License
This project is open-source under the MIT License.

---

⚡ *Developed with Flutter ❤️ for better ECG Monitoring!*

