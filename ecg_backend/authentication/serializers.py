from rest_framework import serializers
from django.contrib.auth.models import User
from .models import UserProfile

class UserRegistrationSerializer(serializers.ModelSerializer):
    contact = serializers.CharField(max_length=15, required=True)
    date_of_birth = serializers.DateField(required=False, allow_null=True)
    address = serializers.CharField(required=False, allow_blank=True)
    password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = ['username', 'password', 'email', 'first_name', 'last_name', 'contact', 'date_of_birth', 'address']

    def validate_username(self, value):
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError("Username already taken")
        return value

    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already registered")
        return value

    def create(self, validated_data):
        password = validated_data.pop('password')  
        user = User.objects.create_user(
            username=validated_data['username'],
            password=password,
            email=validated_data['email'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', '')
        )
        UserProfile.objects.create(
            user=user,
            contact=validated_data['contact'],
            full_name=f"{validated_data.get('first_name', '')} {validated_data.get('last_name', '')}".strip(),
            date_of_birth=validated_data.get("date_of_birth"),
            address=validated_data.get("address", "")
        )
        return user
