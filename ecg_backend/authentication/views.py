from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.models import User
from .models import UserProfile
from .serializers import UserRegistrationSerializer
from rest_framework.decorators import api_view
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication

class RegisterUserView(APIView):
    def post(self, request):
        # print(request.data)
        serializer = UserRegistrationSerializer(data=request.data)

        if serializer.is_valid():
            user = serializer.save()  # Calls create() in serializer

            # Generate auth token for the user
            token, _ = Token.objects.get_or_create(user=user)

            return Response({
                "success": True,
                "message": "User registered successfully!",
                "token": token.key
            }, status=status.HTTP_201_CREATED)

        return Response({"success": False, "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


class GetUserProfileView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, username):
        try:
            user = User.objects.get(username=username)
            profile = user.profile

            return Response({
                "success": True,
                "username": user.username,
                "email": user.email,
                "full_name": profile.full_name,
                "contact": profile.contact,
                "date_of_birth": profile.date_of_birth.strftime('%Y-%m-%d') if profile.date_of_birth else None,
                "address": profile.address
            }, status=status.HTTP_200_OK)

        except User.DoesNotExist:
            return Response({"success": False, "message": "User not found"}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
def login_user(request):
    username = request.data.get("username")
    password = request.data.get("password")

    if not username or not password:
        return Response({"success": False, "message": "Username and password are required"}, status=status.HTTP_400_BAD_REQUEST)

    user = authenticate(username=username, password=password)

    if user:
        token, _ = Token.objects.get_or_create(user=user)
        return Response({
            "success": True,
            "message": "Login successful",
            "token": token.key,
            "username": user.username,
            "email": user.email,
            "full_name": f"{user.first_name} {user.last_name}"
        }, status=status.HTTP_200_OK)

    return Response({"success": False, "message": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['POST'])
def logout_user(request):
    if request.user.is_authenticated:
        request.user.auth_token.delete()
        return Response({"success": True, "message": "Logged out successfully"}, status=status.HTTP_200_OK)
    return Response({"success": False, "message": "User is not logged in"}, status=status.HTTP_400_BAD_REQUEST)
