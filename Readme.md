# 📌 Attendance Management System - Django Backend

This is the backend for the **Attendance Management System**, built using **Django & Django REST Framework (DRF)**. It provides APIs for managing attendance, users, and authentication.

## 🚀 Features
- User authentication (Login/Register)
- Attendance tracking (Check-in/Check-out)
- API-based data access
- Integration with the Flutter mobile app
- Admin panel for user & attendance management

## 🛠️ Installation & Setup

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/yourusername/attendance-django.git
cd attendance-django

### 2️⃣ Create & Activate Virtual Environment
```bash
python -m venv venv
source venv/bin/activate  # For Mac/Linux
venv\Scripts\activate     # For Windows

### 3️⃣ Install Dependencies
```bash
pip install -r requirements.txt

### 4️⃣ Apply Migrations & Create Superuser
```bash
python manage.py migrate
python manage.py createsuperuser

### 5️⃣ Run the Server
```bash
python manage.py runserver