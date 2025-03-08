# 📌 ECG System - Django Backend

This is the backend for the **ECG System**, built using **Django & Django REST Framework (DRF)**. It provides APIs for connecting hardware ecg reader to mobile application.

## 🚀 Features
- User authentication (Login/Register)
- API-based data access
- Integration with the Flutter mobile app
- Admin panel for user & ecg tracking

## 🛠️ Installation & Setup

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/Kaditya67/ecg_project.git
cd ecg_backend
```

### 2️⃣ Create & Activate Virtual Environment
```bash
python -m venv venv
source venv/bin/activate  # For Mac/Linux
venv\Scripts\activate     # For Windows
```

### 3️⃣ Install Dependencies
```bash
pip install -r requirements.txt
```

### 4️⃣ Apply Migrations & Create Superuser
```bash
python manage.py migrate
python manage.py createsuperuser
```

### 5️⃣ Run the Server
```bash
python manage.py runserver
```
The API will be available at **http://127.0.0.1:8000/**

---

## 📜 License
This project is licensed under the **MIT License**.

---

## 🤝 Contribution
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m "Added new feature"`).
4. Push to your branch (`git push origin feature-branch`).
5. Create a pull request.

---

## 📧 Contact
For any issues, contact: **ojhaaditya913@gmail.com**

