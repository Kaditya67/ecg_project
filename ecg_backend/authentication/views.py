from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.models import User
from .models import UserProfile
from .serializers import UserRegistrationSerializer

class RegisterUserView(APIView):
    def post(self, request):
        print(request.data)
        serializer = UserRegistrationSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()  # Calls create() in serializer
            return Response({"success": True, "message": "User registered successfully!"}, status=status.HTTP_201_CREATED)

        return Response({"success": False, "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


class GetUserProfileView(APIView):
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
