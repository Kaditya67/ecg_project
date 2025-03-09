from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
from django.http import JsonResponse
from rest_framework.decorators import api_view
from .models import UserProfile

@api_view(['POST'])
def register_user(request):
    try:
        data = request.data

        # Check if username already exists
        if User.objects.filter(username=data["username"]).exists():
            return JsonResponse({"success": False, "message": "Username already taken"}, status=400)

        # Create User
        user = User.objects.create(
            username=data["username"],
            password=make_password(data["password"]),  # Hash the password
            email=data["email"],
            first_name=data["first_name"],
            last_name=data["last_name"]
        )

        # Create User Profile
        UserProfile.objects.create(
            user=user,
            contact=data["contact"],
            full_name=f"{data['first_name']} {data['last_name']}",
            date_of_birth=data.get("date_of_birth"),
            address=data.get("address")
        )

        return JsonResponse({"success": True, "message": "User registered successfully!"}, status=201)

    except Exception as e:
        return JsonResponse({"success": False, "message": str(e)}, status=400)


@api_view(['GET'])
def get_user_profile(request, username):
    try:
        user = User.objects.get(username=username)
        profile = user.profile

        return JsonResponse({
            "success": True,
            "username": user.username,
            "email": user.email,
            "full_name": profile.full_name,
            "contact": profile.contact,
            "date_of_birth": profile.date_of_birth,
            "address": profile.address
        }, status=200)

    except User.DoesNotExist:
        return JsonResponse({"success": False, "message": "User not found"}, status=404)
